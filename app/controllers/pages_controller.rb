class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_page, only: [:show, :edit, :update, :undo_last_audit, :like, :dislike, :destroy]


  def index
    @categories = Category.order(:name).pluck(:name)
    if params[:filter]
      if params[:filter] == 'All'
        @pages  = Page.all.order(updated_at: :desc)
      else
        @pages  = Page.tagged_with(params[:filter]).order(updated_at: :desc)
      end
    elsif params[:state].present? and current_user and current_user.admin?
      @pages    = Page.where(state: params[:state]).all
    elsif params[:state].present?
      @pages    = Page.where(state: params[:state]).all
    elsif params[:query].present?
      @pages    = Page.page_tsearch(params[:query])
    elsif params[:author_pid].present?
      author    = User.find_by_pid(params[:author_pid])
      @pages    = Page.where(author_id: author.id).order(updated_at: :desc).all
    else
      @pages    = Page.order(updated_at: :desc).limit(10)
    end
  end

  def show
  end

  def new
    if params[:state] == 'Suggestion'
      @page = Page.new(state: 'Suggestion')
    else
      @page = Page.new
    end
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    # else
    #   redirect_to pricing_path(goal: 'page'), alert: 'Please upgrade your Membership Plan!'
    # end
  end

  def create
    if params[:commit] == 'Save and Publish' and current_user.role != 'admin'
      params[:page][:state] = 'Published'
      @page = Page.new(page_params)
    else
      @page = Page.new(page_params)
    end

    if @page.state == 'Published'
      @page.save
    else
      @page.save_without_auditing
    end

    if @page.persisted?
      Notifier.jk_object_created(@page).deliver
      redirect_to page_path(@page), notice: 'Knowledge Base Entry was successfully created.'
    else
      render :new
    end
  end

  def edit
    # if %w[entrepreneur alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
    #   true
    # else
    #   redirect_to pricing_path(goal: 'page'), alert: 'Please upgrade your Membership Plan!'
    # end
  end

  def update

    # if we're coming in as a non-admin suggestion, it's a new author
    if current_user.role != 'admin' and @page.state == 'Suggestion'
      params[:page][:author_id] = current_user.id
    end

    if current_user.role != 'admin' and @page.state == 'Published' or params[:commit] == 'Save and Publish'
      params[:page][:state] = 'Published'
      if @page.update(page_params)
        redirect_to page_path, notice: 'Knowledge Base Entry was successfully updated.' and return
      else
        render :edit
      end
    elsif params[:commit] == 'Update this Suggestion' and @page.author == current_user
      @page.assign_attributes(page_params)
      if @page.save_without_auditing
        redirect_to page_path, notice: 'Knowledge Base Entry was successfully updated.' and return
      else
        render :edit
      end
    elsif params[:commit] == 'Save as Draft'
      params[:page][:state] = 'Draft'
      @page.assign_attributes(page_params)
      if @page.save_without_auditing
        redirect_to page_path, notice: 'Knowledge Base Entry was successfully updated.' and return
      else
        render :edit
      end
    elsif current_user.admin?
      # set the state I sent you and decide audit on that.
      if params[:page][:state] != 'Published'
        @page.assign_attributes(page_params)
        if @page.save_without_auditing
          redirect_to page_path, notice: 'Knowledge Base Entry was successfully updated.' and return
        else
          render :edit
        end
      else
        if @page.update(page_params)
          redirect_to page_path, notice: 'Knowledge Base Entry was successfully updated.' and return
        else
          render :edit
        end
      end
    end
  end

  # PUT /kb/:pid/like
  def like
    current_user.likes @page
    redirect_to @page
  end

  # PUT /kb/:pid/dislike
  def dislike
    current_user.dislikes @page
    redirect_to @page
  end

  # 0) We know that an update with only tag changes doesn't create a new revision/audit
  # 1) We know that undo creates new audit and we'd rather it didn't (goal: true redo)
  # POST
  def undo_last_audit
    @page = @page.revisions.second_to_last # revisions.last == @page so fetch 2nd to last
    if @page.save
      redirect_to page_path, notice: 'Knowledge Base Entry was reverted.'
    else
      redirect_to page_path, alert: 'Unknown error. Cannot undo.'
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_path, alert: 'Knowledge Base Entry was successfully destroyed.'
  end

  private

    def set_page
      if params[:rev]
        @page = Page.find_by_pid(params[:id]).revision(params[:rev].to_i)
      else
        @page = Page.find_by_pid(params[:id])
      end
    end

    def page_params
      params.require(:page).permit(:title, :content, :state, :author_id, :category_list).merge(category_list: params[:page][:category_list])
    end

end
