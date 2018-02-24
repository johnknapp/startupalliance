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
      @post.mark_as_read! for: current_user
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

  # POST
  def mark_posts_read
    if params[:discussion_id].present?
      these = Discussion.find_by_pid(params[:discussion_id]).posts
    elsif params[:topic_id].present?
      these = Topic.find_by_pid(params[:topic_id]).posts
    end
    if Post.mark_collection_as_read(these, current_user)
      redirect_back fallback_location: discussions_path, alert: 'Those Posts were marked as unread'
    else
      redirect_back fallback_location: discussions_path, alert: 'There was an error!'
    end
  end

  private

    def post_params
      params.require(:post).permit(:body, :author_id, :topic_id, :parent_id, :pid)
    end

    def set_post
      @post = Post.find_by_pid(params[:id])
    end

end

