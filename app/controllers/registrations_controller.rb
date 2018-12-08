class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:membership, :edit, :update, :setup_profile, :set_skills, :set_traits, :destroy] # adding to their defaults
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
    redirect_back(fallback_location: users_set_traits_path)
  end

  def unset_trait
    if current_user and params[:trait_id]
      UserTrait.where(user_id: current_user.id, trait_id: params[:trait_id]).first.destroy
      set_trait_index
    end
    redirect_back(fallback_location: users_set_traits_path)
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
    redirect_back(fallback_location: users_set_skills_path)
  end

  def unset_skill
    if current_user and params[:skill_id]
      UserSkill.where(user_id: current_user.id, skill_id: params[:skill_id]).first.destroy
      set_skill_index
    end
    redirect_back(fallback_location: users_set_skills_path)
  end

  def change_plan
    if current_user and params[:user][:plan_id]
      new_plan = Plan.find(params[:user][:plan_id])  # our plan objects

      if params[:user][:stripe_coupon_code].present?
        stripe_coupon_code = params[:user][:stripe_coupon_code]
      else
        stripe_coupon_code = nil
      end

      sub = current_user.first_sub      # retrieves the subscription object from Stripe

      # Set sub.trial_end appropriately based on existing sub.trial_end and new plan.trial_days
      #   sub.trial_end  = null         give new_plan.trial_days unless 0 then nil
      #   sub.trial_end  = past         give new_plan.trial_days unless 0 then nil
      #   sub.trial_end  = future       retain existing sub.trial_end
      # This logic prevents abuse by changing plans to continually extend trial_end
      if sub.trial_end < Time.now.to_i or sub.trial_end == nil        # expired or blank
        if new_plan.trial_period_days == 0                            # blank
          trial_end = nil                                             # no trial
        else                                                          # expired
          trial_end = (Time.now+(new_plan.trial_period_days).days).to_i # give new trial
        end
      else                                                            # still on trial
        trial_end = sub.trial_end                                     # keep existing trial_end
      end

      Stripe::Subscription.update(
          sub.id,
          trial_end:        trial_end,                                # based on logic above
          plan:             new_plan.stripe_id,
          coupon:           stripe_coupon_code
      )

      current_user.update(plan_id: new_plan.id, subscription_state: sub.status, stripe_coupon_code: stripe_coupon_code)
      GibbonService.add_update(current_user, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
    end
    redirect_back(fallback_location: users_membership_path, alert: 'You changed your plan')
  end

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    if params[:terms].blank?
      redirect_back(fallback_location: root_path, alert: 'You must accept Privacy Statement and Terms of Use') and return
    end

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
      customer = Stripe::Customer.create(email: current_user.email)
      current_user.update_attribute(:stripe_customer_id, customer.id)
      # if we don't know what plan they asked for, give them a free plan
      plan = params[:user][:plan_id].present? ? Plan.find(params[:user][:plan_id].to_i) : Plan.where(amount: 0).first
      coupon  = params[:user][:stripe_coupon_code]
      current_user.subscribe_to_stripe(plan,coupon) if plan and current_user.stripe_customer_id
      current_user.update_attribute(:username, current_user.pid) if current_user.username.blank? # making sure they have one
      # current_user.update(first_name: 'noname', last_name: 'setyet') # just for now.
      if Rails.env.production?
        GibbonService.add_update(current_user, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
      end
      # add new user to entity
      add_user_to_entity(current_user,entity,token,role) if params[:user][:entity]
    else
      redirect_back(fallback_location: root_path, alert: 'Either your email is invalid... or you’re a robot!') and return
    end
  end

  def setup_profile
    @user = current_user
  end

  def update
    params[:user][:branch_ids] ||= []
    super
    if Rails.env.production?
      GibbonService.add_update(resource, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
    end
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

  def set_skill
  end

  def set_trait
  end

  def membership
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

    # Specifically not destroying any companies, okrs, FASTs or alliances they created
    def departure_cleanup

      # TODO remove their conversations
      # TODO remove their companies

      okrs = Okr.where(owner_id: @user.id).all
      if okrs.present?
        okrs.each do |okr|
          okr.update(owner_id: okr.company.creator.id)
        end
      end

      fasts = Fast.where(user_id: @user.id).all
      if fasts.present?
        fasts.each do |fast|
          fast.update(user_id: fast.company.creator.id)
        end
      end

      jk = User.where(email: 'john@startupalliance.com').first if Rails.env.production?
      jk = User.find 1 if Rails.env.development?
      Page.where(author_id: resource.id).update_all(author_id: jk.id)          if resource.pages.present?
      Alliance.where(creator_id: resource.id).update_all(creator_id: jk.id)    if resource.alliances.present?
      # pages = Page.where(author_id: @user.id).all
      # pages.update_all(author_id: jk.id)        if pages    # reset the author
      # alliances = Alliance.where(creator_id: @user.id).all
      # alliances.update_all(creator_id: jk.id)   if alliances # reset the creator

      Stripe::Customer.retrieve(id: @user.stripe_customer_id).delete if @user.stripe_customer_id
    end

end
