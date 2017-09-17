class PagesController < ApplicationController
  def home
    # respond_to do |format|
    #   format.html { render layout: 'wide_layout'}
    # end
  end

  def members
    @members = User.where(state: 'active').all
  end

  def join_thanks
  end

  def activate_thanks
    @user = current_user
  end

  def faq
  end

  def code_of_conduct
  end

  def about
  end

  def plans
  end

  def privacy
  end

  def terms
  end

  def quick_start
  end

  def sandbox
  end

end