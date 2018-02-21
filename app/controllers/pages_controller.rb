class PagesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_page, only: [:show, :edit, :update, :undo_last_audit, :destroy]


  def index
    @categories = Category.order(:name).pluck(:name)
    if params[:filter]
      if params[:filter] == 'All'
        @pages  = Page.all.order(updated_at: :desc)
      else
        @pages  = Page.tagged_with(params[:filter]).order(updated_at: :desc)
      end
    elsif params[:query].present?
      @pages    = Page.tsearch_search(params[:query])
    else
      @pages  = Page.order(updated_at: :desc).limit(10)
    end

  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      Notifier.tell_jk(@page).deliver
      redirect_to pages_path, notice: 'Knowledge Base Entry was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to page_path, notice: 'Knowledge Base Entry was successfully updated.'
    else
      render :edit
    end
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
      params.require(:page).permit(:title, :content, :author_id, :category_list).merge(category_list: params[:page][:category_list])
    end

end
