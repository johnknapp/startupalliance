class DiscussionsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource find_by: :pid

  before_action :set_discussion, only: [:show, :edit, :destroy]

  def new
    @discussion = Discussion.new
  end

  def create
    if params[:discussion][:company_pid]
      @discussable = Company.find_by_pid(params[:discussion][:company_pid])
      @discussion  = @discussable.discussions.build(discussion_params)
      if @discussion.save
        redirect_to company_path(@discussable), notice: 'Discussion created'
      else
        redirect_to company_path(@discussable), alert: 'There was a problem'
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if params[:discussion][:company_pid]
      @company = Company.find_by_pid params[:discussion][:company_pid]
      if @discussion.update(discussion_params)
        redirect_to company_path(@company), notice: 'Discussion created'
      else
        redirect_to company_path(@company), alert: 'There was a problem'
      end
    end
  end

  def destroy
    @discussion.destroy
    redirect_back(fallback_location: root_path)
  end

  private

    def discussion_params
      params.require(:discussion).permit(:title, :description, :discussable_id, :discussable_type, :pid)
    end

    def set_discussion
      @discussion = Discussion.find_by_pid(params[:id])
    end

end

