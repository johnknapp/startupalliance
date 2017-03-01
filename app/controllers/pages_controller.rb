class PagesController < ApplicationController
  def home
    # respond_to do |format|
    #   format.html { render layout: 'wide_layout'}
    # end
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

  def matt_sandbox
  end

end