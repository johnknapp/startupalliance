class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:update, :destroy]
  load_and_authorize_resource

  # POST
  def create
    topic = Topic.find params[:post][:topic_id]
    @post = Post.new(post_params)
    @post.topic_id = topic.id
    if @post.save
      # Notifier.tell_jk(@post).deliver
      redirect_to discussion_topic_path(topic.discussion,topic), alert: 'Post was successfully created.'
    else
      redirect_to discussion_topic_path(topic.discussion,topic), alert: 'There was a problem!'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to discussion_topic_path(@post.topic.discussion,@post.topic), notice: 'Post was successfully updated'
    else
      redirect_to discussion_topic_path(@post.topic.discussion,@post.topic), alert: 'There was a problem!'
    end
  end

  def destroy
    @post.destroy
    redirect_back fallback_location: root_path, alert: 'Post was successfully destroyed.'
  end

  private

    def post_params
      params.require(:post).permit(:body, :author_id, :topic_id, :parent_id, :pid)
    end

    def set_post
      @post = Post.find_by_pid(params[:id])
    end

end

