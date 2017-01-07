class PagesController < ApplicationController
  def home
    respond_to do |format|
      format.html { render layout: 'wide_layout'}
    end
  end
end