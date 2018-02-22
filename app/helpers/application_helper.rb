module ApplicationHelper

  def gvo_url(minus_hours = 0)
    time = Time.now.utc.beginning_of_day-minus_hours.hours
    'https://meet.jit.si/sa-gvo-' + Digest::SHA1.hexdigest(time.to_s)
  end

  # default options: https://en.gravatar.com/site/implement/images/
  def gravatar_url(email, size)
    gravatar = Digest::MD5::hexdigest(email).downcase
    url = "http://gravatar.com/avatar/#{gravatar}.png?s=#{size}&d=wavatar"
  end

end