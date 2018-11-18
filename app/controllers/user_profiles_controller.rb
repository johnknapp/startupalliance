class UserProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def edit
    # this path used on signup
  end

  def update
    if @user.update(user_params)
      # to thanks activate if new or vanity_url if existing
      if Rails.application.routes.recognize_path(request.referrer)[:controller] == 'user_profiles'
        redirect_to how_it_works_path, notice: 'You set up your profile!'
      else
        redirect_to vanity_path(@user.username), notice: 'You updated your profile!'
      end
    else
      errors = Hash.new
      @user.errors.full_messages.each do |e|
        errors.store(e,e)
      end
      redirect_to(users_setup_profile_path, flash: errors, error: 'true')
    end
  end

  private

    def set_user
      @user = User.find_by_pid(params[:id])
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :work_role_primary, :work_role_secondary, :mission, :twitter_profile, :linkedin_profile, :website, :country_code, :time_zone)
    end

end