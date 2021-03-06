class OkrsController < ApplicationController
  include DateConverter
  before_action :set_okr, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /okrs
  # GET /okrs.json
  # def index
  #   @okrs = Okr.all
  # end

  # GET /okrs/1
  # GET /okrs/1.json
  def show
  end

  # GET /okrs/new
  def new
    @okr = Okr.new
    @company = Company.find_by_pid(params[:company_pid])
  end

  # GET /okrs/1/edit
  def edit
    @company = Company.find_by_pid(params[:company_pid])
  end

  # POST /okrs
  # POST /okrs.json
  def create
    @okr = Okr.new(okr_params)
    @okr.okr_start = string_to_date(params[:okr][:okr_start])
    @company = Company.find @okr.company_id

    respond_to do |format|
      if @okr.save
        @okr.set_okr_finish
        Notifier.jk_object_created(@okr).deliver
        format.html { redirect_to company_path(@company), notice: 'OKR was successfully created.' }
        format.json { render :show, status: :created, location: @okr }
      else
        format.html { render :new }
        format.json { render json: @okr.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /okrs/1
  # PATCH/PUT /okrs/1.json
  def update
    respond_to do |format|
      okr_start = string_to_date(params[:okr][:okr_start])
      params[:okr].delete :okr_start
      if @okr.update(okr_params)
        @okr.update_attribute(:okr_start, okr_start)
        @okr.set_okr_finish
        @okr.set_score
        @company = Company.find @okr.company_id
        format.html { redirect_to company_path(@company), notice: 'OKR was successfully updated.' }
        format.json { render :show, status: :ok, location: @okr }
      else
        format.html { render :edit }
        format.json { render json: @okr.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /okrs/1
  # DELETE /okrs/1.json
  def destroy
    @okr.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path, notice: 'OKR was successfully destroyed.') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_okr
      @okr = Okr.find_by_pid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def okr_params
      params.require(:okr).permit(:objective, :key_result_1, :key_result_2, :key_result_3, :kr1_score, :kr2_score, :kr3_score, :postmortem, :okr_duration, :okr_units, :okr_start, :okr_finish, :status, :score, :owner_id, :sakpi_id, :company_id, :pid)
    end
end
