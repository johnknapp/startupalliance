class RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  def declare_trait
    if current_user and params[:trait_id] and params[:level]
      trait = UserTrait.where(
          user_id:  current_user.id,
          trait_id: params[:trait_id]
      ).first_or_create
      trait.update(level: params[:level])
      set_trait_index
    end
    redirect_back(fallback_location: vanity_path(current_user.username), notice: 'You set your trait level')
  end

  def unset_trait
    if current_user and params[:trait_id]
      UserTrait.where(user_id: current_user.id, trait_id: params[:trait_id]).first.destroy
      set_trait_index
    end
    redirect_back(fallback_location: vanity_path(current_user.username), alert: 'You unset your trait level')
  end

  def declare_skill
    if current_user and params[:skill_id] and params[:level]
      skill = UserSkill.where(
          user_id:  current_user.id,
          skill_id: params[:skill_id]
      ).first_or_create
      skill.update(level: params[:level])
      set_skill_index
    end
    redirect_back(fallback_location: vanity_path(current_user.username), notice: 'You set your skill level')
  end

  def unset_skill
    if current_user and params[:skill_id]
      UserSkill.where(user_id: current_user.id, skill_id: params[:skill_id]).first.destroy
      set_skill_index
    end
    redirect_back(fallback_location: vanity_path(current_user.username), alert: 'You unset your skill level')
  end

  def change_plan
    if current_user and params[:desired_plan]
      current_user.update_attribute(:plan, params[:desired_plan])
    end
    redirect_back(fallback_location: plans_path, alert: 'You changed your plan')
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
      redirect_back(fallback_location: root_path, alert: 'Please enter your email!') and return
    end

    if valid_email?(params[:user][:email]) == 0 and valid_user?(params['g-recaptcha-response'])
      super
      current_user.update_attribute(:username, 'guest-'+current_user.pid) if current_user.username.blank? # making sure they have one
      current_user.update_attribute(:plan, params[:user][:plan])
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
      redirect_back(fallback_location: root_path, alert: 'Either your email is invalid... or you’re a robot!') and return
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
    departure_cleanup
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

    # jk@johnknapp.com registered at https://www.google.com/recaptcha
    def valid_user?(input)
      conn = Faraday.new('https://www.google.com/recaptcha/api/siteverify')
      conn.params = { secret: RECAPTCHA_SECRET, response: input }
      resp = JSON.parse(conn.post.body)
      resp['success']
    end

    def valid_email?(email)
      valid_email_regex = /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      email =~ valid_email_regex
    end

    def set_skill_index
      us = current_user.user_skills
      current_user.update(skill_index: us.sum(:level))
    end

    def set_trait_index
      us = current_user.user_traits
      current_user.update(trait_index: us.sum(:level))
    end

    # Specifically not destroying any companies, okrs or alliances they created
    def departure_cleanup
      okrs = Okr.where(owner_id: @user.id).all
      if okrs.present?
        okrs.each do |okr|
          okr.update(owner_id: okr.company.creator.id)
        end
      end
      AllianceUser.where(user_id: @user.id).destroy_all
      CompanyUser.where(user_id: @user.id).destroy_all
      UserSkill.where(user_id: @user.id).destroy_all
      UserTrait.where(user_id: @user.id).destroy_all
      Conversation.includes?(@user).destroy_all
    end

end
