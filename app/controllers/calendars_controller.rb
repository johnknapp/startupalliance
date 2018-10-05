class CalendarsController < ApplicationController
  require 'icalendar/tzinfo'

  def upcoming_events
    events = Event.upcoming
    respond_to do |format|
      format.ics do
        cal = Icalendar::Calendar.new
        cal.timezone do |t|
          t.tzid              = 'UTC'
        end
        cal.x_wr_calname = 'Startup Alliance Events'
        events.each do |upcoming_event|
          event               = Icalendar::Event.new
          event.dtstart       = upcoming_event.start_time
          event.dtend         = upcoming_event.start_time+1.hour
          event.summary       = '[SA] ' + upcoming_event.title
          event.url           = event_url(upcoming_event)
          event.description   = upcoming_event.description + ' ' + event_url(upcoming_event)
          cal.add_event(event)
        end
        cal.publish
        render plain: cal.to_ical
      end
    end
  end
end
