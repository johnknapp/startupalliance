class PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_page, only: [:show, :edit, :update, :destroy]


  def index
    @pages  = Page.all.order(updated_at: :desc)
    @sakpis = Sakpi.all.order(:id)
    # @capital_pages            = Sakpi.find(1).pages
    # @cash_flow_pages          = Sakpi.find(2).pages
    # @differentiation_pages    = Sakpi.find(3).pages
    # @growth_pages             = Sakpi.find(4).pages
    # @product_market_fit_pages = Sakpi.find(5).pages
    # @team_pages               = Sakpi.find(6).pages
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
