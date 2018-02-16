class TopicsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_topic, only: [:show, :update, :destroy]

  # POST
  def create
    @topic = Topic.new(topic_params)
    discussion = Discussion.find params[:topic][:discussion_id]
    if @topic.save
      redirect_to discussion_path(discussion), notice: 'Topic was successfully created.'
    else
      redirect_to discussion_path(discussion), alert: 'There was a problem!'
    end
  end

  def show
    @post = Post.new
  end

  def update
    if @topic.update(topic_params)
      redirect_to discussion_path(@topic.discussion), notice: 'Topic was successfully updated.'
    else
      redirect_to discussion_path(@topic.discussion), alert: 'There was a problem!'
    end
  end

  def destroy
    discussion = Discussion.find(@topic.discussion_id)
    @topic.destroy
    redirect_to discussion_path(discussion)
  end

  private

    def set_topic
      @topic = Topic.find_by_pid(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:name, :discussion_id, :author_id)
    end

end
