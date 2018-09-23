class EventsController  < ApplicationController
  include DateConverter
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:create, :clone, :show, :update, :destroy]

  def index
    @event = Event.new
    if params[:filter]
      if params[:filter] == 'All'
        @events  = Event.all.order(:start_time)
      else
        @events  = Event.tagged_with(params[:filter]).order(:start_time)
      end
    elsif params[:query].present?
      @events    = Event.event_tsearch(params[:query])
    elsif params[:organizer_pid].present?
      @organizer        = User.find_by_pid(params[:organizer_pid])
      if @organizer
        @events  = Event.where(organizer_id: @organizer.id).order(:start_time)
      end
    else
      @events    = Event.where('start_time > ?', Time.now).order(:start_time).limit(10)
    end
  end

  def create
    if params[:event][:alliance_id] == '0'
      params[:event][:alliance_id] = nil
    end
    @event = Event.new(event_params)
    flash[:notice] = 'Live Event was successfully created.' if @event.save
    if @event.alliance_id.nil?
      @event.update_attribute(:access_url, WEBRTC_EVENT_URL + @event.pid)
    end
    redirect_to event_path(@event)
  end

  def clone
    if (@event.organizer == current_user) or current_user.admin?
      clone = @event.dup
      clone.start_time = nil
      clone.title = '(CLONE) ' + @event.title
      if clone.organizer != current_user       # This is the admin case  :-)
        clone.organizer_id = current_user.id
      end
      clone.save
      if clone.access_url.present?             # a new room for the clone
        clone.update_attribute(:access_url, WEBRTC_EVENT_URL + clone.pid)
      end
      redirect_to events_path(organizer_pid: current_user.pid), notice: 'Your Event was successfully cloned.'
    else
      redirect_back(fallback_location: events_path, alert: 'There was a problem!')
    end
  end

  def show
    @upcoming_events = Event.where('start_time > ?', Time.now).order(:start_time).limit(10)
  end

  def update
    flash[:notice] = 'Live Event was successfully updated.' if @event.update(event_params)
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
      params[:event][:start_time] = string_24h_to_datetime(params[:event][:start_time])
      params.require(:event).permit(:title, :description, :start_time, :event_type, :alliance_id, :organizer_id)
    end

end