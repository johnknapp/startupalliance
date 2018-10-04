class CalendarsController < ApplicationController

  def upcoming_events
    events = Event.upcoming
    respond_to do |format|
      format.ics do
        cal = Icalendar::Calendar.new
        cal.x_wr_calname = 'Startup Alliance Events'
        events.each do |upcoming_event|
          event               = Icalendar::Event.new
          event.dtstart       = upcoming_event.start_time.utc
          event.dtend         = upcoming_event.start_time.utc+1.hour
          event.summary       = '[SA] ' + upcoming_event.title
          event.url           = event_url(upcoming_event)
          cal.add_event(event)
        end
        cal.publish
        render plain: cal.to_ical
      end
    end
  end
end
