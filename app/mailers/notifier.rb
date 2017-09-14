class Notifier < ApplicationMailer
  def new_message(message)
    @message = message
    if @message.user_id == message.conversation.sender
      @recipient = @message.conversation.sender
    else
      @recipient = @message.conversation.recipient
    end
    mail(to: @recipient.email, subject: "[SA] New message from #{@message.author.name}")
  end
end