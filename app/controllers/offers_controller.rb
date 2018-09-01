class OffersController < ApplicationController

  before_action :prepare_offer

  # GET /welcome/:pid
  def show
    render layout: 'application_blank'
  end

  private

    def prepare_offer
      @offer = Offer.find_by_pid(offer_params[:id])
      @coupon = Stripe::Coupon.retrieve(@offer.coupon) if @offer and @offer.coupon.present?
      unless @offer
        redirect_to root_path, notice: 'Invalid or expired code' and return
      end
    end

    def offer_params
      params.permit(:id)
    end

end
