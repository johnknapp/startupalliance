if Rails.env.production?
  $gibbon = Gibbon::Request.new(api_key: ENV['MAILCHIMP_SITE_MEMBERS_LIST'])
end
