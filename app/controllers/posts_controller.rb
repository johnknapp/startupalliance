class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  def create
    # raise('Chinese finger trap')
    discussion = Discussion.find_by_pid(params[:post][:discussion_id])
    @post = Post.new(comment_params)
    @post.discussion_id = discussion.id
    if @post.save
      # Notifier.tell_jk(@comment).deliver
      redirect_to discussion_path(discussion), alert: 'Your comment was saved.'
    else
      redirect_to discussion_path(discussion), alert: 'There was a problem!'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(comment_params)
      redirect_to discussion_path(@post.discussion), notice: 'Comment updated'
    else
      redirect_to discussion_path(@post.discussion), alert: 'There was a problem!'
    end
  end

  def destroy
    @post.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def comment_params
      params.require(:post).permit(:body, :author_id, :discussion_id, :parent_id, :read, :pid)
    end

    def set_comment
      @post = Post.find_by_pid(params[:id])
    end

end

