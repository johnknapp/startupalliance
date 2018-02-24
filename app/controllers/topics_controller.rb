class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :update, :destroy]

  # POST
  def create
    if %w[entrepreneur alliance company].any? { |necessary_plans| current_user.plan_name == necessary_plans }
      @topic = Topic.new(topic_params)
      discussion = Discussion.find params[:topic][:discussion_id]
      if @topic.save
        redirect_to discussion_path(discussion), notice: 'Topic was successfully created.'
      else
        redirect_to discussion_path(discussion), alert: 'There was a problem!'
      end
    else
      redirect_to pricing_path(goal: 'topic'), alert: 'Please upgrade your Membership Plan!'
    end
  end

  # topics current_user made or in which current_user posted
  def index    # they created
    made_by     = Topic.where(author_id: current_user.id)
    posted_in   = Topic.joins(:posts).where('posts.author_id = ?',current_user.id)
    @topics     = made_by + posted_in
  end

  def show
    @post = Post.new
    # mark_mine_read(@topic.posts)
  end

  def update
    if %w[entrepreneur alliance company].any? { |necessary_plans| current_user.plan_name == necessary_plans }
      if @topic.update(topic_params)
        redirect_to discussion_path(@topic.discussion), notice: 'Topic was successfully updated.'
      else
        redirect_to discussion_path(@topic.discussion), alert: 'There was a problem!'
      end
    else
      redirect_to pricing_path(goal: 'topic'), alert: 'Please upgrade your Membership Plan!'
    end
  end

  def destroy
    discussion = Discussion.find(@topic.discussion_id)
    @topic.destroy
    redirect_to discussion_path(discussion)
  end

  private

    # mark these posts as unread by current_user
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
