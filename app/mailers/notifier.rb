class Notifier < ApplicationMailer

  def new_message(message)
    @message    = message
    @recipient  = @message.other_party
    mail(to: @recipient.email, subject: "[SA] New message from #{@message.author.name}")
  end

  def tell_jk(object)
    if Rails.env.production?
      @object = object
      mail(to: 'john@startupalliance.com', subject: "[SA] New #{@object.class.name} created!")
    end
  end

end