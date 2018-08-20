class AlliancesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_alliance, only: [:show, :join_alliance, :add_alliance_member, :remove_alliance_member, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /alliances
  # GET /alliances.json
  def index
    if params[:filter]
      if params[:filter] == 'All'
      elsif params[:filter] == 'Recruiting Alliances'
        @alliances    = Alliance.where(state: 'Active').where(recruiting: true).order(created_at: :desc).all
      end
    elsif params[:query].present?
      @alliances    = Alliance.where(state: 'Active').where(is_unlisted: false).alliance_tsearch(params[:query])
    elsif params[:creator_pid].present?
      @creator      = User.find_by_pid(params[:creator_pid])
      if @creator
        @alliances  = Alliance.where(creator_id: @creator.id).order(created_at: :desc).all
      end
    else # 'Latest' aka All!
      if current_user.admin?
        @alliances    = Alliance.where(is_unlisted: false).order(created_at: :desc).all
      else
        @alliances    = Alliance.where(state: 'Active').where(is_unlisted: false).order(created_at: :desc).all
      end
    end
  end

  # GET /alliances/1
  # GET /alliances/1.json
  def show
    @discussion = Discussion.new
  end

  # GET /alliances/new
  def new
    if %w[alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
      @alliance = Alliance.new
    else
      redirect_to users_membership_path, alert: 'Please upgrade to an Alliance or Company Membership!'
    end
  end

  # GET /alliances/1/edit
  def edit
    if %w[alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
      true
    else
      redirect_to users_membership_path, alert: 'Please upgrade to an Alliance or Company Membership!'
    end
  end

  def join_alliance
    if %w[alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
      if @alliance.members.include? current_user
        redirect_back(fallback_location: alliance_path, alert: 'Already a member!')
      else
        @alliance.members << current_user
        redirect_back(fallback_location: alliance_path, alert: 'You joined this Alliance!')
      end
    else
      redirect_to users_membership_path, alert: 'Please upgrade to an Alliance or Company Membership!'
    end
  end

  # PUT /alliances/1/add_member?username=taso
  def add_alliance_member
    member =  User.where('lower(username) = ?', params[:username].downcase).first
    if member.blank?
      redirect_back(fallback_location: alliance_path, alert: 'Nobody with that username!')
    elsif @alliance.members.include? member
      redirect_back(fallback_location: alliance_path, alert: 'Already a member!')
    else
      @alliance.members << member
      redirect_back(fallback_location: alliance_path, notice: 'Member added.')
    end
  end

  def remove_alliance_member
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
    if %w[alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
      @alliance = Alliance.new(alliance_params)

      respond_to do |format|
        if @alliance.save
          Notifier.jk_object_created(@alliance).deliver
          @alliance.update(invite_token: SecureRandom.urlsafe_base64)
          @alliance.members << current_user
          format.html { redirect_to @alliance, notice: 'Alliance was successfully created.' }
          format.json { render :show, status: :created, location: @alliance }
        else
          format.html { render :new }
          format.json { render json: @alliance.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to users_membership_path, alert: 'Please upgrade to an Alliance or Company Membership!'
    end
  end

  # PATCH/PUT /alliances/1
  # PATCH/PUT /alliances/1.json
  def update
    if %w[alliance company].any? { |necessary_subscriptions| current_user.subscription == necessary_subscriptions }
      respond_to do |format|
        if current_user == @alliance.creator
          if @alliance.update(alliance_params)
            format.html { redirect_to @alliance, notice: 'Alliance was successfully updated.' }
            format.json { render :show, status: :ok, location: @alliance }
          else
            format.html { render :edit }
            format.json { render json: @alliance.errors, status: :unprocessable_entity }
          end
        else
          redirect_back(fallback_location: root_path, alert: 'You are not the creator of this Alliance!')
        end
      end
    else
      redirect_to users_membership_path, alert: 'Please upgrade to an Alliance or Company Membership!'
    end
  end

  # DELETE /alliances/1
  # DELETE /alliances/1.json
  def destroy
    @alliance.destroy
    respond_to do |format|
      format.html { redirect_to vanity_path(current_user.username), notice: 'Alliance was successfully destroyed.' }
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
      params.require(:alliance).permit(:is_unlisted, :name, :mission, :webmeet_code, :pid, :recruiting, :creator_id, :invite_only, :state)
    end
end
