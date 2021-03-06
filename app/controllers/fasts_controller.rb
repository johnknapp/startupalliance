class FastsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fast, only: [:show, :edit, :update, :destroy]

  # GET /fasts/new
  def new
    @fast = Fast.new
    @company = Company.find_by_pid(params[:company_pid])
    @factor = Fast.find_by_pid(params[:factor_pid])
  end

  # GET /fasts/1/edit
  def edit
    @company = Company.find_by_pid(params[:company_pid])
  end

  # POST /fasts
  # POST /fasts.json
  def create
    @fast = Fast.new(fast_params)
    company = Company.find_by_pid params[:fast][:company_pid]
    factor = Fast.find_by_pid params[:fast][:factor_pid]

    respond_to do |format|
      if @fast.save
        @fast.update(body: 'default') if @fast.body.blank?
        @fast.update(company_id: company.id)
        @fast.factors << factor if factor.present?
        format.html { redirect_to company_path(company), notice: 'FAST was successfully created.' }
        format.json { redirect_to company_path(company), status: :created, location: @fast }
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
        @fast.update(body: 'default') if @fast.body.blank?
        format.html { redirect_to company_path(@fast.company), notice: 'FAST was successfully updated.' }
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
      format.html { redirect_to company_path(@fast.company), notice: 'FAST was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fast
      @fast = Fast.find_by_pid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fast_params
      params.require(:fast).permit(:body, :type_code, :company_id, :user_id, :okr_id, :sakpi_id)
    end
end
