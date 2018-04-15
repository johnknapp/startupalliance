class CardsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  # POST /cards
  def create
    # raise('tasty foo')
    customer = Stripe::Customer.retrieve(id: current_user.stripe_customer_id)
    customer.sources.create(card: card_params[:token])
    # TODO add card details to current_user
    redirect_to edit_user_registration_path, notice: 'Payment source successfully added'
  end

  def destroy
  end

  private

    def card_params
      params.permit(:token)
    end

end