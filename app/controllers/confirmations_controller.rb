class ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    if params[:confirmation_token].present?
      self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token]) if params[:confirmation_token].present?
      # self.resource.update_attribute(:username, nil) # erase it because they're about to be required to make their own
      super if resource.nil? or resource.confirmed?
    else
      redirect_to root_path
    end
  end

  def confirm
    self.resource = resource_class.find_by_confirmation_token(params[resource_name][:confirmation_token]) if params[resource_name][:confirmation_token].present?
    resource.assign_attributes(permitted_params) unless params[resource_name].nil?
    resource.update(state: 'active', role: 'user')

    if resource.valid? && resource.password_match?
      self.resource.confirm
      if Rails.env.production?
        GibbonService.add_update(resource, ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
        # $analytics.identify(
        #     anonymous_id:       resource.pid,
        #     id:                 resource.pid,
        #     created_at:         resource.created_at,
        #     traits: {
        #         first_name:     resource.first_name,
        #         last_name:      resource.last_name,
        #         state:          resource.state,
        #         username:       resource.username
        #     },
        #     context: {
        #         anonymous_id:   resource.pid,
        #         ip:             resource.current_sign_in_ip,
        #         logins:         resource.sign_in_count
        #     }
        # )
        # $analytics.track(
        #     anonymous_id:       resource.pid,
        #     id:                 resource.pid,
        #     event:              'Activated'
        # )
      end
      set_flash_message :notice, :confirmed
      sign_in(resource)
      if %w[alliance company].any? { |necessary_subscriptions| resource.subscription == necessary_subscriptions }
        alliance = Alliance.find_by_pid 'fast-track'
        alliance.members << resource
      end
      redirect_to thanks_activate_path
      # sign_in_and_redirect resource_name, resource
    else
      redirect_to controller: 'confirmations', action: 'show', confirmation_token: resource.confirmation_token, error: 'true'
    end
  end

  # protected

    # The path used after resending confirmation instructions.
    # def after_resending_confirmation_instructions_path_for(resource_name)
    #   super(resource_name)
    # end

    # The path used after confirmation.
    # def after_confirmation_path_for(resource_name, resource)
    #   super(resource_name, resource)
    # end

  private

    def permitted_params
      params.require(resource_name).permit(:first_name, :last_name, :company_owner, :username, :time_zone, :confirmation_token, :work_role, :country_code, :password, :password_confirmation)
    end

end
