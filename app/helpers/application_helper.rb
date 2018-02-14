module ApplicationHelper

  def gvo_url(minus_hours = 0)
    time = Time.now.utc.beginning_of_day-minus_hours.hours
    'https://meet.jit.si/sa-gvo-' + Digest::SHA1.hexdigest(time.to_s)
  end

end