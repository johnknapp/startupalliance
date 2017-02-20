class RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  def declare_trait
    if current_user and params[:trait_id] and params[:level]
      UserTrait.create(
          user_id:  current_user.id,
          trait_id: params[:trait_id],
          level:    params[:level] 
      )
    end
    redirect_to :back, notice: 'You set your level'
  end

  def unset_trait
    if current_user and params[:trait_id]
      UserTrait.where(user_id: current_user.id, trait_id: params[:trait_id]).first.destroy
    end
    redirect_to :back, alert: 'You unset your level'
  end

  def declare_skill
    if current_user and params[:skill_id] and params[:level]
      UserSkill.create(
          user_id:  current_user.id,
          skill_id: params[:skill_id],
          level:    params[:level]
      )
    end
    redirect_to :back, notice: 'You set your level'
  end

  def unset_skill
    if current_user and params[:skill_id]
      UserSkill.where(user_id: current_user.id, skill_id: params[:skill_id]).first.destroy
    end
    redirect_to :back, alert: 'You unset your level'
  end

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create

    if params[:user][:email].present?
      email = params[:user][:email]
      user = User.find_by_email(email)
      if user
        redirect_to user_session_path, notice: 'You are already a member. Please sign-in!' and return
      end
    elsif params[:user][:email].blank?
      redirect_to :back, alert: 'You need to enter a valid email address!' and return
    end

    if valid_email?(params[:user][:email])
      super
      current_user.update_attribute(:username, 'guest-'+current_user.pid) if current_user.username.blank? # making sure they have one
      if Rails.env.production?
        # $analytics.identify(
        #     anonymous_id:   current_user.pid,
        #     id:             current_user.pid,
        #     created_at:     current_user.created_at,
        #     traits: {
        #         email:      current_user.email,
        #         acqsrc:     current_user.acqsrc,
        #         state:      current_user.state,
        #         username:   current_user.username     # use guest username to identify unactivated users
        #     },
        #     context: {
        #         ip:         current_user.current_sign_in_ip,
        #         logins:     current_user.sign_in_count
        #     }
        # )
        # $analytics.track(
        #     anonymous_id:   current_user.pid,
        #     id:             current_user.pid,
        #     event:          'Signed up'
        # )
        GibbonService.add_update(current_user, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
      end
      current_or_guest_user
    else
      redirect_to :back, alert: 'You need to enter a valid email address!' and return
    end

  end

  def update
    params[:user][:branch_ids] ||= []
    if resource.save
      if Rails.env.production?
        # $analytics.identify(
        #     anonymous_id:   resource.pid,
        #     id:             resource.pid,
        #     created_at:     resource.created_at,
        #     traits: {
        #         email:      resource.email,
        #         acqsrc:     resource.acqsrc,
        #         state:      resource.state,
        #         username:   resource.username     # use guest username to identify unactivated users
        #     },
        #     context: {
        #         ip:         resource.current_sign_in_ip,
        #         logins:     resource.sign_in_count
        #     }
        # )
        # $analytics.track(
        #     anonymous_id:   resource.pid,
        #     id:             resource.pid,
        #     event:          'Updated account'
        # )
        GibbonService.add_update(resource, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
      end
    end
    super
  end

  def show
    if params[:username]
      if User.find_by_username(params[:username])
        @user = User.find_by_username(params[:username])
      else
        redirect_to root_path, alert: 'Not found!'
        # render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      end
    end
  end

  def destroy
    if Rails.env.production?
      GibbonService.unsubscribe(@user, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
    end
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

    def after_sign_up_path_for(resource)
      join_thanks_path
    end

    def after_update_path_for(resource)
      vanity_path(resource.username)
    end

  private

    def valid_email?(email)
      valid_email_regex = /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      email =~ valid_email_regex
    end

end
