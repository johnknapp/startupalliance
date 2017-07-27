class MessagesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_conversation,  only: [:index, :new, :create]
  before_action :set_message,       only: [:destroy]

  def index
    @messages = @conversation.messages
    if @messages.length > 10
      @over_ten = true
      @messages = @messages[-10..-1]
    end
    if params[:m]
      @over_ten = false
      @messages = @conversation.messages
    end
    if @messages.last
      if @messages.last.user_id != current_user.id
        @messages.last.is_read = true
      end
    end
    @message = @conversation.messages.new
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end
  end

  def destroy
    if @message.author == current_user
      @message.destroy
    end
    redirect_to conversation_messages_path
  end

  private

    def message_params
      params.require(:message).permit(:body, :user_id)
    end

    def set_conversation
      @conversation = Conversation.find_by_pid(params[:conversation_id])
    end

    def set_message
      @message = Message.find_by_pid(params[:id])
    end

end