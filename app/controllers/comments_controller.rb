class CommentsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy]
  load_and_authorize_resource


  def create
    # raise('Chinese finger trap')
    discussion = Discussion.find_by_pid(params[:comment][:discussion_id])
    @comment = Comment.new(comment_params)
    @comment.discussion_id = discussion.id
    if @comment.save
      # Notifier.tell_jk(@comment).deliver
      redirect_to discussion_path(discussion), alert: 'Your comment was saved.'
    else
      redirect_to discussion_path(discussion), alert: 'There was a problem!'
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to discussion_path(@comment.discussion), notice: 'Comment updated'
    else
      redirect_to discussion_path(@comment.discussion), alert: 'There was a problem!'
    end
  end

  def destroy
    @comment.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :author_id, :discussion_id, :parent_id, :read, :pid)
    end

    def set_comment
      @comment = Comment.find_by_pid(params[:id])
    end

end

