class QuarksController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  before_action :set_quark, only: [:update, :destroy]

  def index
    if params[:filter]
      if params[:filter] == 'Top Quarks'
        @quarks = Quark.where(state: 'Promoted').order(created_at: :desc)
      elsif params[:filter] == 'Contributed'
        @quarks = Quark.where(state: 'Contributed').order(:created_at)
      else
        @quarks = Quark.where.not(state: 'Flagged').order(created_at: :desc)
      end
    elsif params[:query]
      @quarks = Quark.quark_tsearch(params[:query]).where.not(state: 'Flagged').order(created_at: :desc)
    elsif params[:author_pid]
      @author    = User.find_by_pid(params[:author_pid])
      if @author
        @quarks  = Quark.where.not(state: 'Flagged').where(author_id: @author.id).order(updated_at: :desc).all
      end
    else
      @quarks = Quark.where.not(state: 'Flagged').order(created_at: :desc)
    end
  end

  def create
    @quark = Quark.new(quark_params)
    if @quark.save
      redirect_to quarks_path, notice: 'Your Quark has been successfully created.'
    else
      render :new, alert: 'There was a problem!'
    end
  end

  def update
    if (@quark and @quark.author_id == current_user.id) or current_user.admin?
      if @quark.update(quark_params)
        redirect_to quarks_path, notice: 'Your Quark has been successfully updated.'
      else
        render quarks_path, alert: 'There was a problem!'
      end
    else
      redirect_to quarks_path, alert: 'There was a problem!'
    end
  end

  def destroy
    if (@quark and @quark.author_id == current_user.id) or current_user.admin?
      @quark.destroy
      redirect_to quarks_path, notice: 'Your Quark has been destroyed.'
    else
      redirect_to quarks_path, alert: 'There was a problem!'
    end
  end


  private

    def quark_params
      params.require(:quark).permit(:text, :author_id, :state)
    end

    def set_quark
      @quark = Quark.find_by_pid(params[:id])
    end

end