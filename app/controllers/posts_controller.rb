class PostsController < InheritedResources::Base
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :destroy]
  load_and_authorize_resource


  # def new
  #   @post = Post.new
  # end

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

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to discussion_path(@post.discussion), notice: 'Post updated'
    else
      redirect_to discussion_path(@post.discussion), alert: 'There was a problem!'
    end
  end

  def destroy
    @post.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def post_params
      params.require(:post).permit(:body, :author_id, :discussion_id, :pid)
    end

    def set_post
      @post = Post.find_by_pid(params[:id])
    end

end

