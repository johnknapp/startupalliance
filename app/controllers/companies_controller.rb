class CompaniesController < ApplicationController
  include DateConverter
  before_action :set_company, only: [:show, :add_team_member, :remove_team_member, :set_sakpi, :unset_sakpi, :edit, :update, :destroy]

  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @okrs = Okr.where(company_id: @company.id).all
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  def set_sakpi
    if @company and params[:sakpi_id] and params[:level]
      sakpi = CompanySakpi.where(
          company_id:  @company.id,
          sakpi_id: params[:sakpi_id]
      ).first_or_create
      sakpi.update(level: params[:level])
      set_sakpi_index
    end
    redirect_back(fallback_location: company_path, notice: 'You set your SAKPI')
  end

  def unset_sakpi
    if @company and params[:sakpi_id]
      CompanySakpi.where(company_id: @company.id, sakpi_id: params[:sakpi_id]).first.destroy
      set_sakpi_index
    end
    redirect_back(fallback_location: company_path, alert: 'You unset your SAKPI')
  end

  # PUT /companies/1/add_team_member
  def add_team_member
    team_member = User.find_by_username(params[:username])
    if !team_member
      redirect_back(fallback_location: company_path, alert: 'Nobody with that username!')
    elsif @company.team.exists? team_member.id
      redirect_back(fallback_location: company_path, alert: 'Already a team member!')
    else
      CompanyUser.create(
          user_id: team_member.id,
          company_id: @company.id,
          role: params[:role],
          equity: params[:equity]
      )
      redirect_back(fallback_location: company_path, notice: 'Team member added.')
    end
  end

  # DELETE
  def remove_team_member
    team_member = User.find_by_pid(params[:team_member_pid])
    if @company.team.count > 1
      @company.team.delete(team_member)
      redirect_back(fallback_location: company_path, notice: 'team_member removed.')
    else
      redirect_back(fallback_location: company_path, alert: 'Cannot remove the last team member, please contact support.')
    end
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.where(company_params).first_or_initialize
    if @company.new_record?
      @company.founded = Date.strptime(params[:company][:founded], '%m/%d/%Y')
      params[:company].delete [:founded]
      respond_to do |format|
        if @company.save
          @company.team << current_user
          CompanyUser.last.update(equity: params[:company][:company_user][:equity]) # strong params for join tables, <sigh>
          format.html { redirect_to @company, notice: 'Company was successfully created.' }
          format.json { render :show, status: :created, location: @company }
        else
          format.html { render :new }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to vanity_path(current_user.username), notice: 'Company already exists!'
    end


  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_registration_path(current_user), notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Update company.sakpi_index with new total
    def set_sakpi_index
      cs = @company.company_sakpis
      @company.update(sakpi_index: cs.sum(:level))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find_by_pid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params[:company][:founded] = string_to_date(params[:company][:founded])
      params.require(:company).permit(:webmeet_url, :name, :mission, :primary_market, :sakpi_index, :phases, :url, :location, :latitude, :longitude, :time_zone, :founded, :state, :recruiting, :creator_id, :pid)
    end
end
