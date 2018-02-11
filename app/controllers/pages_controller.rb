class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: [:show, :edit, :update, :destroy]


  def index
    @pages = Page.all.order(updated_at: :desc)
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to pages_path, notice: 'Wiki page was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to pages_path, notice: 'Wiki page was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @page.destroy
    redirect_to pages_path, alert: 'Wiki page was successfully destroyed.'
  end

  private

    def set_page
      @page = Page.find_by_pid(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :content, :sakpi_ids => [])
    end

end
