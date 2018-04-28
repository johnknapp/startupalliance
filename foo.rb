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
    id: 'intro-company-year',
    product: {
        id: 'intro-company-membership-year',
        name: 'Introductory Annual Company Membership'
    }
)

alliance_year = Stripe::Plan.create(
    trial_period_days: 14,
    amount: 9540,
    currency: 'usd',
    interval: 'year',
    id: 'intro-alliance-year',
    product: {
        id: 'intro-alliance-membership-year',
        name: 'Introductory Annual Alliance Membership'
    }
)

entrepreneur_year = Stripe::Plan.create(
    trial_period_days: 7,
    amount: 5940,
    currency: 'usd',
    interval: 'year',
    # id: 'intro-entrepreneur-year',
    product: {
        # id: 'intro-entrepreneur-membership-year',
        name: 'Introductory Annual Entrepreneur Membership'
    }
)

associate_year = Stripe::Plan.create(
    amount: 0,
    currency: 'usd',
    interval: 'year',
    id: 'intro-associate-life',
    product: {
        id: 'intro-associate-membership-life',
        name: 'Introductory Lifetime Associate Membership'
    }
)

company_month = Stripe::Plan.create(
    trial_period_days: 14,
    amount: 1295,
    currency: 'usd',
    interval: 'month',
    id: 'intro-company-month',
    product: {
        id: 'intro-company-membership-month',
        name: 'Introductory Monthly Company Membership'
    }
)

alliance_month = Stripe::Plan.create(
    trial_period_days: 14,
    amount: 1095,
    currency: 'usd',
    interval: 'month',
    id: 'intro-alliance-month',
    product: {
        id: 'intro-alliance-membership-month',
        name: 'Introductory Monthly Alliance Membership'
    }
)

entrepreneur_month = Stripe::Plan.create(
    trial_period_days: 7,
    amount: 795,
    currency: 'usd',
    interval: 'month',
    id: 'intro-entrepreneur-month',
    product: {
        id: 'intro-entrepreneur-membership-month',
        name: 'Introductory Monthly Entrepreneur Membership'
    }
)

jk = Stripe::Customer.create(email: 'jk@johnknapp.com')

Stripe::Customer.update(jk.id, description: 'awesome')

Stripe::Coupon.create(
    percent_off: 100,
    duration: 'repeating',
    duration_in_months: 6,
    id: '6-months-free'
)

subscription = Stripe::Subscription.create(
    customer: jk.id,
    coupon: '6-months-free', # will fail if invalid
    plan: company-year # or our plan.stripe_id string
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

