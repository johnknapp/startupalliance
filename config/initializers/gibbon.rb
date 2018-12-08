if Rails.env.production?
  $gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'], debug: true)
end
