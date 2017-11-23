class FastsController < ApplicationController
  before_action :set_fast, only: [:show, :edit, :update, :destroy]

  # GET /fasts
  # GET /fasts.json
  def index
    @fasts = Fast.all
  end

  # GET /fasts/1
  # GET /fasts/1.json
  def show
  end

  # GET /fasts/new
  def new
    @fast = Fast.new
  end

  # GET /fasts/1/edit
  def edit
  end

  # POST /fasts
  # POST /fasts.json
  def create
    @fast = Fast.new(fast_params)

    respond_to do |format|
      if @fast.save
        format.html { redirect_to @fast, notice: 'Fast was successfully created.' }
        format.json { render :show, status: :created, location: @fast }
      else
        format.html { render :new }
        format.json { render json: @fast.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fasts/1
  # PATCH/PUT /fasts/1.json
  def update
    respond_to do |format|
      if @fast.update(fast_params)
        format.html { redirect_to @fast, notice: 'Fast was successfully updated.' }
        format.json { render :show, status: :ok, location: @fast }
      else
        format.html { render :edit }
        format.json { render json: @fast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fasts/1
  # DELETE /fasts/1.json
  def destroy
    @fast.destroy
    respond_to do |format|
      format.html { redirect_to fasts_url, notice: 'Fast was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fast
      @fast = Fast.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fast_params
      params.require(:fast).permit(:body, :is_factor, :company_id, :user_id, :pid)
    end
end
