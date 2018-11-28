#   https://github.com/stripe/stripe-ruby
#   https://github.com/integrallis/stripe_event

# Stripe public keys in _constants.rb

if Rails.env.production?
  $stripe_signing_secret        = ENV["STRIPE_ENDPOINT_SECRET"]
  Stripe.api_key                = ENV["STRIPE_API_KEY"]
  Stripe.api_version            = '2018-02-28'
else # dev
  # must use rails s
  # launch ngrok on port 3000, get the url + /stripe_webhooks
  # Create webhook, grab the signing secret and paste it below
  # https://webhook.site is also handy to see what comes in.
  $stripe_signing_secret        = 'whsec_fjUmFJwt9vwk49FAyR59lYfHySFVUb1g' # changes with every new test webhook
  Stripe.api_key                = 'sk_test_0gqafnktKwV7pbt0t1RnWAtu'
  Stripe.api_version            = '2018-02-28'
end