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
      set_category_array
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
      set_category_array
      redirect_to page_path, notice: 'Knowledge Base Entry was successfully updated.'
    else
      render :edit
    end
  end

  def undo_last_audit
    if @page.audits.last.undo
      @page.update_attribute(:category_array, @page.category_list)
      redirect_to page_path, notice: 'Knowledge Base Entry was reverted.'
    else
      redirect_to page_path, alert: 'There was an error.'
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_path, alert: 'Knowledge Base Entry was successfully destroyed.'
  end

  private

    def set_category_array
      @page.category_array = @page.category_list
      @page.save_without_auditing
    end

    def set_page
      @page = Page.find_by_pid(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :content, :category_array, :category_list).merge(category_list: params[:page][:category_list])
    end

end
