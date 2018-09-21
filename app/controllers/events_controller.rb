class EventsController  < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_event, only: [:create, :show, :update, :destroy]

  def index
    @event = Event.new
    if params[:filter]
      if params[:filter] == 'All'
        @events  = Event.all.order(updated_at: :desc)
      else
        @events  = Event.tagged_with(params[:filter]).order(updated_at: :desc)
      end
    elsif params[:query].present?
      @events    = Event.event_tsearch(params[:query])
    elsif params[:organizer_pid].present?
      @organizer        = User.find_by_pid(params[:author_pid])
      if @organizer
        @events  = Event.where(organizer_id: @organizer.id).order(updated_at: :desc)
      end
    else
      @events    = Event.order(updated_at: :desc).limit(10)
    end
  end

  def create
    @event = Event.new(event_params)
    flash[:notice] = 'Event ad was successfully created.' if @event.save
    redirect_to event_path
  end

  def show
  end

  def update
    flash[:notice] = 'Event ad was successfully updated.' if @event.update(event_params)
    redirect_to events_path
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  private

    def set_event
      @event = Event.find_by_pid(params[:id])
    end

    def event_params
      params.require(:event).permit(:title, :description, :start_time, :type, :alliance_id, :organizer_id)
    end

end