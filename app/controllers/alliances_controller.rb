class AlliancesController < ApplicationController
  before_action :set_alliance, only: [:show, :add_member, :remove_member, :edit, :update, :destroy]

  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  # GET /alliances
  # GET /alliances.json
  def index
    @alliances = Alliance.all
  end

  # GET /alliances/1
  # GET /alliances/1.json
  def show
  end

  # GET /alliances/new
  def new
    @alliance = Alliance.new
  end

  # GET /alliances/1/edit
  def edit
  end

  # PUT /alliances/1/add_member
  def add_member
    member = User.find_by_username(params[:username])
    if @alliance.members.exists? member.id
      redirect_back(fallback_location: alliance_path, alert: 'Already a member!')
    else
      @alliance.members << member
      redirect_back(fallback_location: alliance_path, notice: 'Member added.')
    end
  end

  def remove_member
    member = User.find_by_pid(params[:member_pid])
    if @alliance.members.count > 1
      @alliance.members.delete(member)
      redirect_back(fallback_location: alliance_path, notice: 'Member removed.')
    else
      redirect_back(fallback_location: alliance_path, alert: 'Cannot remove the last member, please contact support.')
    end
  end

  # POST /alliances
  # POST /alliances.json
  def create
    @alliance = Alliance.new(alliance_params)

    respond_to do |format|
      if @alliance.save
        @alliance.members << current_user
        format.html { redirect_to @alliance, notice: 'Alliance was successfully created.' }
        format.json { render :show, status: :created, location: @alliance }
      else
        format.html { render :new }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alliances/1
  # PATCH/PUT /alliances/1.json
  def update
    respond_to do |format|
      if @alliance.update(alliance_params)
        format.html { redirect_to @alliance, notice: 'Alliance was successfully updated.' }
        format.json { render :show, status: :ok, location: @alliance }
      else
        format.html { render :edit }
        format.json { render json: @alliance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alliances/1
  # DELETE /alliances/1.json
  def destroy
    @alliance.destroy
    respond_to do |format|
      format.html { redirect_to alliances_url, notice: 'Alliance was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alliance
      @alliance = Alliance.find_by_pid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alliance_params
      params.require(:alliance).permit(:name, :mission, :webmeet_url, :state, :pid, :recruiting, :creator_id)
    end
end
