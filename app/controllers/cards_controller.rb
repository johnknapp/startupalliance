class CardsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  # POST /cards
  def create
    source = Stripe::Customer.retrieve(id: current_user.stripe_customer_id).sources.create(card: card_params[:token])
    if source.present?
      expiry = end_of_month(source.exp_month,source.exp_year)
      current_user.update(card_brand: source.brand, last4: source.last4, card_expiry: expiry)
      redirect_to edit_user_registration_path, notice: 'Payment source successfully added'
    else
      # TODO display error
      redirect_to cards_path, alert: 'There was a problem!'
    end
  end

  def destroy
    customer = Stripe::Customer.retrieve(id: current_user.stripe_customer_id)
    if customer.sources.retrieve(id: customer.default_source).delete
      current_user.update(card_brand: nil, last4: nil, card_expiry: nil)
      redirect_to edit_user_registration_path, notice: 'Payment source successfully removed'
    else
      redirect_to edit_user_registration_path, alert: 'There was a problem!'
    end
  end

  private

    def card_params
      params.permit(:token)
    end

    def end_of_month(m,y)
      Date.new(y,m).end_of_month.end_of_day
    end

end