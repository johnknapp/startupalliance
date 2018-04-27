class StripeMailer < ApplicationMailer
    default from: 'support@startupalliance.com'

  def card_request(user)
    @user = user
    mail(to: @user.email, subject: "Startup Alliance – Your free trial ends soon!")
  end

  def subscription_payment_received(user)
    @user = user
    mail(to: @user.email, subject: "Startup Alliance – Thank you!")
  end

  def subscription_payment_failed(user)
    @user = user
    mail(to: @user.email, subject: "Startup Alliance – Subscription payment failure")
  end

  def migrated_to_associate(user)
    @user = user
    mail(to: @user.email, subject: "Startup Alliance – Free Lifetime Associate Membership")
  end

end