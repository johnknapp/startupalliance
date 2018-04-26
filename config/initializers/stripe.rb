#   https://github.com/stripe/stripe-ruby
#   https://github.com/integrallis/stripe_event

# Stripe public keys in _constants.rb

if Rails.env.production?
  $stripe_signing_secret        = ENV["STRIPE_ENDPOINT_SECRET"]
  Stripe.api_key                = ENV["STRIPE_API_KEY"]
  Stripe.api_version            = '2018-02-28'
else # dev
  $stripe_signing_secret        = 'whsec_g6TXYb1Gpx7yz1n0nC7b0v9xV1sP1dgr'
  Stripe.api_key                = 'sk_test_0gqafnktKwV7pbt0t1RnWAtu'
  Stripe.api_version            = '2018-02-28'
end