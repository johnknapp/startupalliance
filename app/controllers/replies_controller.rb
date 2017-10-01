class RepliesController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_reply, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  def create
    comment = Comment.find_by_pid(params[:reply][:comment_id])
    @reply = Reply.new(reply_params)
    @reply.comment_id = comment.id
    if @reply.save
      Notifier.tell_jk(@reply).deliver
      redirect_to discussion_path(comment.discussion), alert: 'Reply created'
    else
      redirect_to discussion_path(comment.discussion), alert: 'There was a problem!'
    end
  end

  def edit
  end

  def update
    if @reply.update(reply_params)
      redirect_to discussion_path(@reply.comment.discussion), notice: 'Reply updated'
    else
      redirect_to discussion_path(@reply.comment.discussion), alert: 'There was a problem!'
    end
  end

  def destroy
    @reply.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def reply_params
      params.require(:reply).permit(:body, :author_id, :comment_id, :pid)
    end

    def set_reply
      @reply = Reply.find_by_pid(params[:id])
    end

end

