class StaticController < ApplicationController
  before_action :authenticate_user!, only: [:quick_start]

  def home
    # render layout: 'application_wide'
  end

  def h2
  end

  def members
    @members = User.where(state: 'active').all
  end

  def about
  end

  def thanks_guest
    @prospect = Prospect.find_by_email(params[:email])
    @offer    = Offer.find @prospect.offer_id if @prospect
  end

  def thanks_join
  end

  def thanks_activate
    @user = current_user
  end

  def welcome
    render layout: 'application_welcome'
  end

  def nucleus
  end

  def discussions
    @discussions = Discussion.where(nucleus: true).all.order(:name)
  end

  def faq
  end

  def code_of_conduct
  end

  def commitment_pledge
  end

  def pricing
  end

  def sponsorship
  end

  def privacy
  end

  def terms
  end

  def quick_start
  end

  def community_canvas
  end

end