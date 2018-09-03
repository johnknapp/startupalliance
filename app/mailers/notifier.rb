class Notifier < ApplicationMailer

  def new_message(message)
    @message    = message
    @recipient  = @message.other_party
    mail(to: @recipient.email, subject: "[SA] New message from #{@message.author.name}")
  end

  def jk_object_created(object)
    if Rails.env.production?
      @object = object
      mail(to: 'john@startupalliance.com', subject: "[SA] New #{@object.class.name} created!")
    end
  end

  def card_requested(user)
    if Rails.env.production?
      @user = user
      mail(to: 'john@startupalliance.com', subject: "[SA] card request sent")
    end
  end

  def payment_succeeded(user)
    if Rails.env.production?
      @user = user
      mail(to: 'john@startupalliance.com', subject: "[SA] payment succeeded")
    end
  end

  def payment_failed(user)
    if Rails.env.production?
      @user = user
      mail(to: 'john@startupalliance.com', subject: "[SA] payment failed")
    end
  end

  def cancel_for_non_payment(user)
    if Rails.env.production?
      @user = user
      mail(to: 'john@startupalliance.com', subject: "[SA] cancellation for non-payment")
    end
  end

  def bad_request
    if Rails.env.production?
      mail(to: 'john@startupalliance.com', subject: "[SA] check logs for InvalidRequestError")
    end
  end

  def happy_dance(user,event)
    if Rails.env.production?
      @user = user
      @event = event
      mail(to: 'john@startupalliance.com', subject: "[SA] somebody did something")
    end
  end

end