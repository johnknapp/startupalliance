class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :search_results]
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def new
    @topic = Topic.new
  end

  # search topic.name and post.body
  # return distinct topics
  def search_results
    if params[:query]
      arr = []
      results    = PgSearch.multisearch(params[:query])
      results.each do |result|
        if result.searchable_type == 'Topic'
          arr << result.searchable          if result.searchable.discussion.nucleus?
        elsif result.searchable_type == 'Post'
          arr << result.searchable.topic    if result.searchable.topic.discussion.nucleus?
        end
      end
      @topics = arr.uniq#.fresh_posts_first # TODO make that scope work on the array
    else
      redirect_to discussions_path, notice: 'Nothing found!'
    end
  end

  def create

    # This action only works for companies and alliances

    if params[:discussion][:company_pid]
      @discussable = Company.find_by_pid(params[:discussion][:company_pid])
      @discussion  = @discussable.discussions.build(discussion_params)
      if @discussion.save
        redirect_to company_path(@discussable), notice: 'Discussion created'
      else
        redirect_to company_path(@discussable), alert: 'There was a problem!'
      end
    end

    if params[:discussion][:alliance_pid]
      @discussable = Alliance.find_by_pid(params[:discussion][:alliance_pid])
      @discussion  = @discussable.discussions.build(discussion_params)
      if @discussion.save
        redirect_to alliance_path(@discussable), notice: 'Discussion created'
      else
        redirect_to alliance_path(@discussable), alert: 'There was a problem!'
      end
    end

  end

  def show
    @topic = Topic.new
  end

  def update
    if @discussion.update(discussion_params)
      if @discussion.discussable.class.name == 'Company'
        redirect_to company_path(@discussion.discussable), notice: 'Discussion updated'
      elsif @discussion.discussable.class.name == 'Alliance'
        redirect_to alliance_path(@discussion.discussable), notice: 'Discussion updated'
      else
        redirect_to discussion_path, notice: 'Discussion updated'
      end
    else
      redirect_to discussion_path(@discussion), alert: 'There was a problem!'
    end
  end

  def destroy
    @discussion.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def discussion_params
      params.require(:discussion).permit(:name, :slug, :description, :author_id, :discussable_id, :discussable_type, :pid)
    end

    def set_discussion
      @discussion = Discussion.find_by_pid(params[:id])
    end

end

