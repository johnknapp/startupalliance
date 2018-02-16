class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource


  def create
    # raise('Chinese finger trap')
    topic = Topic.find_by_pid(params[:post][:topic_id])
    @post = Post.new(post_params)
    @post.topic_id = topic.id
    if @post.save
      # Notifier.tell_jk(@post).deliver
      redirect_to discussion_topic_path(topic), alert: 'Your Post was saved.'
    else
      redirect_to discussion_topic_path(topic), alert: 'There was a problem!'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to discussion_topic_path(@post.topic), notice: 'Post updated'
    else
      redirect_to discussion_topic_path(@post.topic), alert: 'There was a problem!'
    end
  end

  def destroy
    @post.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def post_params
      params.require(:post).permit(:body, :author_id, :topic_id, :parent_id, :read, :pid)
    end

    def set_post
      @post = Post.find_by_pid(params[:id])
    end

end

