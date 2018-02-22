class DiscussionsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_discussion, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def new
    @topic = Topic.new
  end

  def create

    # TODO leverage discussable to clean this up like #update
    if params[:discussion][:company_pid]
      @discussable = Company.find_by_pid(params[:discussion][:company_pid])
      @discussion  = @discussable.discussions.build(discussion_params)
      if @discussion.save
        Notifier.tell_jk(@discussion).deliver
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
        redirect_to nucleus_path, notice: 'Discussion updated'
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
      params.require(:discussion).permit(:name, :author_id, :discussable_id, :discussable_type, :pid)
    end

    def set_discussion
      @discussion = Discussion.find_by_pid(params[:id])
    end

end

