class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :update, :destroy]

  # POST
  def create
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    @topic = Topic.new(topic_params)
    discussion = Discussion.find params[:topic][:discussion_id]
    if @topic.save
      redirect_to discussion_topic_path(@topic.discussion,@topic), notice: 'Topic was successfully created.'
    else
      redirect_to discussion_path(@topic.discussion), alert: 'There was a problem!'
    end
    # else
    #   redirect_to pricing_path(goal: 'topic'), alert: 'Please upgrade your Membership Plan!'
    # end
  end

  def show
    @post = Post.new
    # mark_mine_read(@topic.posts)
  end

  def update
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    if @topic.update(topic_params)
      redirect_to discussion_path(@topic.discussion), notice: 'Topic was successfully updated.'
    else
      redirect_to discussion_path(@topic.discussion), alert: 'There was a problem!'
    end
    # else
    #   redirect_to pricing_path(goal: 'topic'), alert: 'Please upgrade your Membership Plan!'
    # end
  end

  def destroy
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    discussion = Discussion.find(@topic.discussion_id)
    @topic.destroy
    redirect_to discussion_path(discussion)
    # else
    #   redirect_to pricing_path(goal: 'topic'), alert: 'Please upgrade your Membership Plan!'
    # end
  end

  private

    # mark these posts as read by current_user
    def mark_mine_read(these)
      Post.mark_collection_as_read(these, current_user)
    end

    def set_topic
      @topic = Topic.find_by_pid(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:name, :discussion_id, :author_id)
    end

end
