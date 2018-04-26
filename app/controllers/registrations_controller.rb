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
      plan_interval = current_user.plan_interval
      desired_plan  = params[:desired_plan]
      plan_name     = desired_plan + '_' + plan_interval
      plan = Plan.where(name: plan_name).first
      current_user.update_attribute(:plan_id, plan.id)
      GibbonService.add_update(current_user, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
    end
    redirect_back(fallback_location: pricing_path, alert: 'You changed your plan')
  end

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    if params[:user][:email].present?
      email = params[:user][:email]
      user = User.find_by_email(email)                                        # We know them
      entity = params[:user][:entity].singularize if params[:user][:entity]
      token = params[:user][:token]
      role = params[:user][:r]
      if user
        # add existing non-auth user to entity
        add_user_to_entity(user,entity,token,role) if params[:user][:entity]
        redirect_to user_session_path, notice: 'Please sign-in!' and return
      end
    elsif params[:user][:email].blank?
      redirect_back(fallback_location: root_path, alert: 'Please enter your email!') and return
    end

    if valid_email?(params[:user][:email]) == 0 and valid_user?(params['g-recaptcha-response'])
      super

      # Stripe:
      #   We always want to have a Customer
      #   We create Subscription if we get a valid plan_id from the join form
      #   We apply a Coupon if they submit a valid one
      #     Keep constants in sync with the Coupons!
      #     TODO: Check the Coupon against Stripe and abandon the constant

      customer = Stripe::Customer.create(email: current_user.email)
      current_user.update_attribute(:stripe_customer_id, customer.id)
      plan = Plan.where(id: params[:user][:plan_id]).first
      if plan.present? # should be fine unless join forms suck
        if VALID_STRIPE_COUPONS.include? params[:user][:stripe_coupon_code]
          coupon  = params[:user][:stripe_coupon_code]
          subscription = Stripe::Subscription.create(
              customer: customer.id,
              coupon: coupon,
              plan: plan.stripe_id
          )
        else
          current_user.update_attribute(:stripe_coupon_code, nil) # they tricked us with invalid coupon so nil it
          subscription = Stripe::Subscription.create(
              customer: customer.id,
              plan: plan.stripe_id
          )
        end
        if subscription
          # subscription_states = %w[trialing active past_due canceled unpaid error]
          if current_user.associate?
            current_user.update_attribute(:subscription_state, 'unpaid')
          elsif !current_user.associate? and current_user.plan.trial_period_days != 0
            current_user.update_attribute(:subscription_state, 'trialing')
          elsif !current_user.associate? or current_user.plan.trial_period_days == 0
            current_user.update_attribute(:subscription_state, 'active')
          else # something is fishy
            current_user.update_attribute(:subscription_state, 'error')
          end
          current_user.update_attribute(:subscription_state, 'unpaid')
          current_user.update_attribute(:subscribed_at, Time.now)
        end
      end
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
      # add new user to entity
      add_user_to_entity(current_user,entity,token,role) if params[:user][:entity]
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
      thanks_join_path
    end

    def after_update_path_for(resource)
      vanity_path(resource.username)
    end

  private

    def add_user_to_entity(user,entity,token,r)
      if entity == 'company'
        role = 'Owner'      if r == '0'
        role = 'Employee'   if r == '1'
        role = 'Advisor'    if r == '2'
        role = 'Consultant' if r == '3'
        role = 'Investor'   if r == '4'
        company = Company.find_by_invite_token(token)
        company.team << user
        company_user = CompanyUser.where(company_id: company.id).where(user_id: user.id)
        company_user.update(role: role)
      end
      if entity == 'alliance'
        alliance = Alliance.find_by_invite_token(token)
        alliance.member << user
      end
    end

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
      jk = User.where(email: 'john@startupalliance.com') if Rails.env.production?
      jk = User.find 1 if Rails.env.development?
      Page.where(author_id: @user.id).update_all(author_id: jk.id) # reset the author
      AllianceUser.where(user_id: @user.id).destroy_all
      CompanyUser.where(user_id: @user.id).destroy_all
      UserSkill.where(user_id: @user.id).destroy_all
      UserTrait.where(user_id: @user.id).destroy_all
      Conversation.includes?(@user).destroy_all
      Stripe::Customer.retrieve(id: @user.stripe_customer_id).delete if @user.stripe_customer_id
    end

end
