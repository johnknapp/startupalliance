class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:update, :destroy, :mark_post_read]
  load_and_authorize_resource

  # POST
  def create
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    topic = Topic.find params[:post][:topic_id]
    @post = Post.new(post_params)
    @post.topic_id = topic.id
    if @post.save
      @post.mark_as_read! for: current_user
      # Notifier.jk_object_created(@post).deliver
      redirect_to discussion_topic_path(topic.discussion,topic), alert: 'Post was successfully created.'
    else
      redirect_to discussion_topic_path(topic.discussion,topic), alert: 'There was a problem!'
    end
    # else
    #   redirect_to pricing_path(goal: 'post'), alert: 'Please upgrade your Membership Plan!'
    # end
  end

  def update
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    if @post.update(post_params)
      redirect_to discussion_topic_path(@post.topic.discussion,@post.topic), notice: 'Post was successfully updated'
    else
      redirect_to discussion_topic_path(@post.topic.discussion,@post.topic), alert: 'There was a problem!'
    end
    # else
    #   redirect_to pricing_path(goal: 'post'), alert: 'Please upgrade your Membership Plan!'
    # end
  end

  def destroy
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    @post.destroy
    redirect_back fallback_location: root_path, alert: 'Post was successfully destroyed.'
    # else
    #   redirect_to pricing_path(goal: 'post'), alert: 'Please upgrade your Membership Plan!'
    # end
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

  # POST
  def mark_post_read
    if @post.mark_as_read!(for: current_user)
      redirect_back fallback_location: discussions_path, alert: 'That post was marked as unread'
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

