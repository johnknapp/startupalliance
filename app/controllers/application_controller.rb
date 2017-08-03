class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method [:current_or_guest_user]
  before_action :configure_permitted_parameters,  if:     :devise_controller?
  before_action :store_current_location,          unless: :devise_controller?

  impersonates :user

  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if cookies.signed[:guest_user_email]
        logging_in
        guest_user.delete
        cookies.delete :guest_user_email
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with a permanent cookie, creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find_by!(email: (cookies.permanent.signed[:guest_user_email] ||= create_guest_user.email))

  rescue ActiveRecord::RecordNotFound
    cookies.delete :guest_user_email
    guest_user # start fresh
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to main_app.root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
      user_params.permit(
          :email, :acqsrc, :plan, :time_zone
      )
    end

    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:email, :password, :remember_me)
    end

    devise_parameter_sanitizer.permit(:account_update) do |user_params|
      user_params.permit(
          :first_name,
          :last_name,
          :username,
          :mission,
          :bio,
          :email,
          :password,
          :password_confirmation,
          :current_password,
          :skill_index,
          :trait_index,
          :company_owner,
          :twitter_profile,
          :linkedin_profile,
          :website,
          :location,
          :time_zone,
          :public_skills,
          :public_traits
      )
    end

  end

  # called (once) when user signs in or up, handle the hand off from guest_user to current_user of each thing.
  def logging_in
    # guest_activities       = guest_user.activities.where(contributor_id: guest_user.id).all
    # if guest_activities.present?
    #   guest_activities.each do |g|
    #     g.contributor.id = current_user.id
    #     g.save
    #   end
    # end
  end

  private

    def store_current_location
      store_location_for(:user, request.url)
    end

    def create_guest_user
      u = User.new(first_name: 'Guest', last_name: 'User', role: 'guest', email: "guest_#{Time.zone.now.to_i}#{rand(100..999)}@example.com")
      u.pid = Generator.pid(u)
      u.username = 'guest-' + u.pid
      u.skip_confirmation_notification!
      u.save!(:validate => false)
      u
    end

end
