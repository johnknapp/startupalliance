class CommentsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy]
  load_and_authorize_resource


  # def new
  #   @comment = Comment.new
  # end

  def create
    discussion = Discussion.find_by_pid(params[:comment][:discussion_id])
    @comment = Comment.new(post_params)
    @comment.discussion_id = discussion.id
    if @comment.save
      Notifier.tell_jk(@comment).deliver
      redirect_to discussion_path(discussion), alert: 'Your comment was saved.'
    else
      redirect_to discussion_path(discussion), alert: 'There was a problem!'
    end
  end

  def edit
  end

  def update
    if @comment.update(post_params)
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

    def post_params
      params.require(:comment).permit(:body, :author_id, :discussion_id, :pid)
    end

    def set_post
      @comment = Comment.find_by_pid(params[:id])
    end

end

