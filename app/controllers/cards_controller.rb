class CardsController < ApplicationController
  before_action :authenticate_user!,              except: [:stripe_webhooks]
  skip_before_action :verify_authenticity_token,  only:   [:stripe_webhooks]

  def new
  end

  # POST /cards
  def create
    source = Stripe::Customer.retrieve(id: current_user.stripe_customer_id).sources.create(card: card_params[:token])
    if source.present?
      expiry = end_of_month(source.exp_month,source.exp_year)
      current_user.update(card_brand: source.brand, last4: source.last4, card_expiry: expiry)
      redirect_to user_membership_path, notice: 'Payment source successfully added'
    else
      # TODO display error
      redirect_to cards_path, alert: 'There was a problem!'
    end
  end

  def destroy
    customer = Stripe::Customer.retrieve(id: current_user.stripe_customer_id)
    if customer.sources.retrieve(id: customer.default_source).delete
      current_user.update(card_brand: nil, last4: nil, card_expiry: nil)
      redirect_to user_membership_path, notice: 'Payment source successfully removed'
    else
      redirect_to user_membership_path, alert: 'There was a problem!'
    end
  end

  def stripe_webhooks
    receive_webhook
    if @event
      if RELEVANT_STRIPE_WEBHOOKS.any? { |hook| @event.type == hook }
        StripeWebhookService.new(@event)
      end
      head :no_content, status: :accepted
    else
      head :no_content, status: :internal_server_error
    end
  end

  private

    def receive_webhook
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
      endpoint_secret = $stripe_signing_secret
      @event = nil
      begin
        @event = Stripe::Webhook.construct_event(
            payload, sig_header, endpoint_secret
        )
      rescue JSON::ParserError => e
        # Invalid payload
        status 400
        return
      rescue Stripe::SignatureVerificationError => e
        # Invalid signature
        status 400
        return
      end
    end

    def card_params
      params.permit(:token)
    end

    def end_of_month(m,y)
      Date.new(y,m).end_of_month.end_of_day
    end

end
