class PostsController < InheritedResources::Base
  before_action :authenticate_user!
  load_and_authorize_resource find_by: :pid

  before_action :set_post, only: [:show, :edit, :destroy]

  def new
    @post = Post.new
  end

  def create
    discussion = Discussion.find_by_pid(params[:post][:discussion_id])
    @post = Post.new(post_params)
    @post.discussion_id = discussion.id
    if @post.save
      redirect_to discussion_path(discussion), alert: 'Your post was saved.'
    else
      redirect_to discussion_path(discussion), alert: 'There was a problem!'
    end
  end

  private

    def post_params
      params.require(:post).permit(:body, :discussion_id, :pid)
    end

    def set_post
      @post = Post.find_by_pid(params[:id])
    end

end

