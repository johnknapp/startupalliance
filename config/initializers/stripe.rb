#   https://github.com/stripe/stripe-ruby
#   https://github.com/integrallis/stripe_event

if Rails.env.production?
  StripeEvent.signing_secret    = ENV["STRIPE_SIGNING_SECRET"]
  Stripe.api_key                = ENV["STRIPE_SECRET_KEY"]
  Stripe.api_version            = '2017-12-14'
else # dev
  StripeEvent.signing_secret    = ''
  Stripe.api_key                = 'sk_test_0gqafnktKwV7pbt0t1RnWAtu'
  Stripe.api_version            = '2017-12-14'
end