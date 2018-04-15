params = {"utf8"=>"✓", "authenticity_token"=>"r+8wGCDx4XsWQKKitoc+y89r2AfA5pN41Onw/sXj+bBwRG/UfwSeQg8s8CJb5WWJKlKFciYcSzxFZoh3eenGAw==", "user"=>{"acqsrc"=>"home_page", "plan_id"=>"5", "email"=>""}, "g-recaptcha-response"=>"", "stripeToken"=>"tok_1BqppOG82GK6HBTxOSR9Ug7B", "stripeTokenType"=>"card", "stripeEmail"=>"foodie@bar.com"}

Company.all.each do |c|
  c.update(webmeet_code:  Generator.code(6))
end

Alliance.all.each do |a|
  a.update(webmeet_code:  Generator.code(6))
end

User.update_all(subscribed_at: Time.now)
User.update_all(subscription_expires_at: Time.now.beginning_of_month-3.months+1.year)
User.update_all(subscription_state: 'unpaid')

company_year = Stripe::Plan.create(
    trial_period_days: 14,
    amount: 11940,
    currency: 'usd',
    interval: 'year',
    id: 'company-year',
    product: {
        id: 'company-membership-year',
        name: 'Annual Company Membership'
    }
)

alliance_year = Stripe::Plan.create(
    trial_period_days: 14,
    amount: 9540,
    currency: 'usd',
    interval: 'year',
    id: 'alliance-year',
    product: {
        id: 'alliance-membership-year',
        name: 'Annual Alliance Membership'
    }
)

entrepreneur_year = Stripe::Plan.create(
    trial_period_days: 7,
    amount: 5940,
    currency: 'usd',
    interval: 'year',
    id: 'entrepreneur-year',
    product: {
        id: 'entrepreneur-membership-year',
        name: 'Annual Entrepreneur Membership'
    }
)

associate_year = Stripe::Plan.create(
    amount: 0,
    currency: 'usd',
    interval: 'year',
    id: 'associate-year',
    product: {
        id: 'associate-membership-year',
        name: 'Annual Associate Membership'
    }
)

company_month = Stripe::Plan.create(
    trial_period_days: 14,
    amount: 1295,
    currency: 'usd',
    interval: 'month',
    id: 'company-month',
    product: {
        id: 'company-membership-month',
        name: 'Monthly Company Membership'
    }
)

alliance_month = Stripe::Plan.create(
    trial_period_days: 14,
    amount: 1095,
    currency: 'usd',
    interval: 'month',
    id: 'alliance-month',
    product: {
        id: 'alliance-membership-month',
        name: 'Monthly Alliance Membership'
    }
)

entrepreneur_month = Stripe::Plan.create(
    trial_period_days: 7,
    amount: 795,
    currency: 'usd',
    interval: 'month',
    id: 'entrepreneur-month',
    product: {
        id: 'entrepreneur-membership-month',
        name: 'Monthly Entrepreneur Membership'
    }
)

jk = Stripe::Customer.create(email: 'jk@johnknapp.com')

Stripe::Customer.update(jk.id, description: 'awesome')

subscription = Stripe::Subscription.create(
    customer: jk.id,
    plan: company_year.id # or our plan.stripe_id string
)

# Subscribing creates a $0 invoice for trial period, paid in full
#     and another invoice due at trial end for subscription price
#     subscription period is trial end date for one year.

# Subscribing without a payment source is fine
#     Just as long as there is a source by the end of the trial
#     The trial_will_end webhook lets us email customer to add a source (provides 3 day warning)

# It's easy to set end date for a trial
wrap_up = Time.now+10.days
Stripe::Subscription.update(subscription.id, trial_end: wrap_up.to_i)

# or extend it
subscription = Stripe::Subscription.retrieve(subscription.id)
new_wrap_up = Time.at(subscription.trial_end)+10.days
Stripe::Subscription.update(subscription.id, trial_end: new_wrap_up.to_i)

subscription.delete # immediately
subscription.delete(at_period_end: true) # if trialing, at trial period end

# Generating a card token via api incurs PCI compliance issues
#     It's preferable to use Checkout or Elements client side

token = Stripe::Token.create(
    card: {
        number: 4242424242424242,
        exp_month: 12,
        exp_year: 20,
        cvc: 123
    }
)

customer = Stripe::Customer.retrieve(id: jk.id)

# Once you have a token, it's easy to add a source to a customer

customer.sources.create(card: token.id)

customer.default_source

customer.delete # all gone

User.all.each do |u|
  customer = Stripe::Customer.create(email: u.email)
  puts customer.id
  u.stripe_customer_id = customer.id
  u.save
end

