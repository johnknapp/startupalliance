class ClassifiedsController  < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_classified, only: [:create, :update, :ad_response, :destroy]

  def index
    @classified = Classified.new
    if params[:filter]
      if params[:filter] == 'All'
        @classifieds  = Classified.all.order(updated_at: :desc)
      else
        @classifieds  = Classified.tagged_with(params[:filter]).order(updated_at: :desc)
      end
    elsif params[:query].present?
      @classifieds    = Classified.classified_tsearch(params[:query])
    elsif params[:author_pid].present?
      @author        = User.find_by_pid(params[:author_pid])
      if @author
        @classifieds  = Classified.where(creator_id: @author.id).order(updated_at: :desc)
      end
    else
      @classifieds    = Classified.order(updated_at: :desc).limit(10)
    end
  end

  def create
    @classified = Classified.new(classified_params)
    flash[:notice] = 'Classified ad was successfully created.' if @classified.save
    redirect_to classifieds_path
  end

  def update
    flash[:notice] = 'Classified ad was successfully updated.' if @classified.update(classified_params)
    redirect_to classifieds_path
  end

  def ad_response
    sender    = User.find_by_pid params[:classified][:sender_pid]
    recipient = @classified.creator
    response  = '(Your classified ad: ' + @classified.title + ') ' + params[:response]
    if sender.present? and recipient.present?
      if Conversation.between(sender.id,recipient.id).present?
        conversation = Conversation.between(sender.id,recipient.id).first
      else
        conversation = Conversation.create!(sender_id: sender.id, recipient_id: recipient.id)
      end
      message = Message.new(body: response, conversation_id: conversation.id, user_id: sender.id)
      if message.save
        flash[:notice] = 'Your message has been sent.'
        redirect_to classifieds_path
      else
        flash[:alert] = 'There was an error, message not sent!'
        redirect_to classifieds_path
      end
    else
      flash[:alert] = 'There was an error, message not sent!'
      redirect_to classifieds_path
    end
  end

  def destroy
    @classified.destroy
    redirect_to classifieds_path
  end

  private

    def set_classified
      @classified = Classified.find_by_pid(params[:id])
    end

    def classified_params
      params.require(:classified).permit(:title, :body, :creator_id)
    end

end