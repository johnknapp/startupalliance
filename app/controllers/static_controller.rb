class StaticController < ApplicationController
  before_action :authenticate_user!, only: [:quick_start]

  def home
    # render layout: 'application_wide'
  end

  def members
    @members = User.where(state: 'active').all
  end

  def join_thanks
  end

  def activate_thanks
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

  def pricing
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