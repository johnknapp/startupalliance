class ConversationsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_interlocutors
  before_action :set_conversation, only: [:destroy]

  def index
    @conversations = Conversation.includes?(current_user)
  end

  def create
    if params[:sender_pid].present? and params[:recipient_pid].present?
      if Conversation.between(@sender.id,@recipient.id).present?
        @conversation = Conversation.between(@sender.id,@recipient.id).first
      else
        @conversation = Conversation.create!(sender_id: @sender.id, recipient_id: @recipient.id)
      end
      redirect_to conversation_messages_path(@conversation)
    else
      redirect_to :back, alert: 'There was a problem!'
    end
  end

  def destroy
    if @conversation.sender == current_user or @conversation.recipient == current_user
      @conversation.destroy
    end
    redirect_to conversations_path
  end

  private

    def conversation_params
      params.permit(:sender_id, :recipient_id, :pid)
    end

    def set_interlocutors
      if params[:sender_pid].present? and params[:recipient_pid].present?
        @sender     = User.find_by_pid(params[:sender_pid])
        @recipient  = User.find_by_pid(params[:recipient_pid])
      end
    end

    def set_conversation
      @conversation = Conversation.find_by_pid(params[:id])
    end

end