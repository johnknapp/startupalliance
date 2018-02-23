class SessionsController < Devise::SessionsController

  def impersonate
    user = User.find_by_pid(params[:pid])
    impersonate_user(user)
    redirect_to vanity_path(user.username)
  end

  def stop_impersonating
    user = current_user
    stop_impersonating_user
    redirect_back(fallback_location: root_path)
  end

  # POST /resource/sign_in
  def create
    super
    current_or_guest_user
    if Rails.env.production?
      # $analytics.identify(
      #     anonymous_id:   current_user.pid,
      #     id:             current_user.pid,
      #     created_at:     current_user.created_at,
      #     traits: {
      #         logins:     current_user.sign_in_count,
      #         first_name: current_user.first_name,
      #         last_name:  current_user.last_name,
      #         state:      current_user.state,
      #         username:   current_user.username
      #     },
      #     context: {
      #         ip:         current_user.current_sign_in_ip,
      #         logins:     current_user.sign_in_count
      #     }
      # )
      # $analytics.track(
      #     anonymous_id:   current_user.pid,
      #     id:             current_user.pid,
      #     event:          'Signed in'
      # )
    end
  end

  def destroy
    if Rails.env.production?
      # $analytics.track(
      #     anonymous_id:       current_user.pid,
      #     id:                 current_user.pid,
      #     event:              'Signed out'
      # )
    end
    super
  end

end
