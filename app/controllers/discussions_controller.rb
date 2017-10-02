class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def new
    @comment = Comment.new
  end

  def create

    if params[:discussion][:company_pid]
      @discussable = Company.find_by_pid(params[:discussion][:company_pid])
      @discussion  = @discussable.discussions.build(discussion_params)
      if @discussion.save
        Notifier.tell_jk(@discussion).deliver
        redirect_to discussion_path(@discussion), notice: 'Discussion created'
      else
        redirect_to company_path(@discussable), alert: 'There was a problem!'
      end
    end

    if params[:discussion][:alliance_pid]
      @discussable = Alliance.find_by_pid(params[:discussion][:alliance_pid])
      @discussion  = @discussable.discussions.build(discussion_params)
      if @discussion.save
        redirect_to discussion_path(@discussion), notice: 'Discussion created'
      else
        redirect_to alliance_path(@discussable), alert: 'There was a problem!'
      end
    end

  end

  def show
    @comment = Comment.new
  end

  def edit
  end

  def update
    if @discussion.update(discussion_params)
      redirect_to discussion_path(@discussion), notice: 'Discussion updated'
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
      params.require(:discussion).permit(:topic, :author_id, :discussable_id, :discussable_type, :pid)
    end

    def set_discussion
      @discussion = Discussion.find_by_pid(params[:id])
    end

end

