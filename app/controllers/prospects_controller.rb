class ProspectsController < ApplicationController

  # POST /prospects
  def create
    if valid_email?(prospect_params[:email]) == 0 and valid_user?(params['g-recaptcha-response'])
      # TODO handle repeated subscriptions
      prospect = Prospect.new(prospect_params)
      if prospect.save
        if Rails.env.production?
          GibbonService.add_update(prospect, ENV['MAILCHIMP_PROPECTS_LIST'])
        end
        if prospect.offer_id
          redirect_to thanks_guest_path(email: prospect.email)
        else
          redirect_to root_path, notice: 'Thank you for subscribing!'
        end
      else
        redirect_back(fallback_location: root_path, alert: 'There was a problem!')
      end
    else
      redirect_back(fallback_location: root_path, alert: 'Either your email is invalid... or you’re a robot!')
    end
  end

  def mailchimp_webhook
    # prospect = Prospect.find_by_email
    # prospect.update(subscribed: false)
  end

  private

    def prospect_params
      params.require(:prospect).permit(:email, :acqsrc, :offer_id)
    end

    def valid_email?(email)
      valid_email_regex = /\A([-a-z0-9!\#$%&'*+\/=?^_`{|}~]+\.)*[-a-z0-9!\#$%&'*+\/=?^_`{|}~]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      email =~ valid_email_regex
    end

    # jk@johnknapp.com registered at https://www.google.com/recaptcha
    def valid_user?(input)
      conn = Faraday.new('https://www.google.com/recaptcha/api/siteverify')
      conn.params = { secret: RECAPTCHA_SECRET, response: input }
      resp = JSON.parse(conn.post.body)
      resp['success']
    end

end
