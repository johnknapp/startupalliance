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
    nickname: 'intro_company_year',
    trial_period_days: 14,
    amount: 11940,
    currency: 'usd',
    interval: 'year',
    product: {
        name: 'Annual Company Membership'
    }
)

alliance_year = Stripe::Plan.create(
    nickname: 'intro_alliance_year',
    trial_period_days: 14,
    amount: 9540,
    currency: 'usd',
    interval: 'year',
    product: {
        name: 'Annual Alliance Membership'
    }
)

entrepreneur_year = Stripe::Plan.create(
    nickname: 'intro_entrepreneur_year',
    trial_period_days: 7,
    amount: 5940,
    currency: 'usd',
    interval: 'year',
    product: {
        name: 'Annual Entrepreneur Membership'
    }
)

associate_year = Stripe::Plan.create(
    nickname: 'intro_associate_year',
    amount: 0,
    currency: 'usd',
    interval: 'year',
    product: {
        name: 'Lifetime Associate Membership'
    }
)

company_month = Stripe::Plan.create(
    nickname: 'intro_company_month',
    trial_period_days: 14,
    amount: 1295,
    currency: 'usd',
    interval: 'month',
    product: {
        name: 'Monthly Company Membership'
    }
)

alliance_month = Stripe::Plan.create(
    nickname: 'intro_alliance_month',
    trial_period_days: 14,
    amount: 1095,
    currency: 'usd',
    interval: 'month',
    product: {
        name: 'Monthly Alliance Membership'
    }
)

entrepreneur_month = Stripe::Plan.create(
    nickname: 'intro_entrepreneur_month',
    trial_period_days: 7,
    amount: 795,
    currency: 'usd',
    interval: 'month',
    product: {
        name: 'Monthly Entrepreneur Membership'
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

# TODO POLICY: We call coupons "option codes"
# TODO POLICY: Stripe.plan.nickname   == Plan.name
# TODO POLICY: Our Plan.display_name  == Stripe Product Name

# nuke them all
splans = Stripe::Plan.list
splans.each do |sp|
  prod = Stripe::Product.retrieve(id: sp.product)
  Stripe::Plan.retrieve(sp.id).delete
  prod.delete
end

plans = Plan.all
plans.each do |p|
  # p.display_name = p.display_name.slice! 'Introductory '
  p.save
end

# synchronize stripe plan.id to our plans:
splans = Stripe::Plan.list
splans.each do |sp|
  Plan.find_by_name(sp.nickname).update(stripe_id: sp.id)
end

# sync stripe product name with local plan display name
splans = Stripe::Plan.list
splans.each do |sp|
  prod = Stripe::Product.retrieve(id: sp.product)
  Plan.find_by_name(sp.nickname).update(display_name: prod.name)
end

# resolve subscriptions and set state
users = User.all
users.each do |u|
  if u.first_sub.blank?            # only if no subscription
    plan = Plan.find u.plan_id
    if plan.name == 'intro_associate_year'
      sub = Stripe::Subscription.create(customer: u.stripe_customer_id, plan: plan.stripe_id)
      u.update(subscription_state: sub.status)
    else
      sub = Stripe::Subscription.create(customer: u.stripe_customer_id, plan: plan.stripe_id, coupon: 'beta6')
      u.update(subscription_state: sub.status)
    end
  end
end

# resolve user.subscription_state
users = User.all
users.each do |u|
  if u.first_sub
    u.update(subscription_state: u.first_sub.status)
  end
end


alliances = [
    {        name: "Business models & customer discovery",
             mission: "Deciding what we sell, how we sell it and how we get to sustainable product/market fit." },

    {        name: "Capitalization & cash flow",
             mission: "Raising money, achieving profitability and controlling costs." },

    {        name: "Founders, team & advisors",
             mission: "We know our success demands the right people doing the right things right." },

    {        name: "Ideation & validation",
             mission: "This is where we come up with a great idea, turn it into a real business and make sure it’s viable." },

    {        name: "Legal, IP & corporate structure",
             mission: "Doing the right thing with Contracts, Agreements, Patents & Trademarks and our corporate structure." },

    {        name: "Marketing, growth & sales",
             mission: "Optimizing our positioning, voice and messaging, choosing the right growth hacks and essential analytics, effective advertising, funnels and strategic partnerships." },

    {        name: "Product planning, production & design",
             mission: "We know that bringing a great product to market takes more than a good idea and fresh design. This is where we get it right." },

    {        name: "Productivity hacks & time management",
             mission: "Taking advantage of the best tips, tricks and tools for getting our work done on time and keeping our priorities straight." },

    {        name: "Revenue models & pricing",
             mission: "We know it’s essential to provide solid value to customers and price our products and services correctly and in response to market forces." },

    {        name: "Software, engineering & technology",
             mission: "The tools and tech we love, the processes and strategies we employ. What works and what doesn’t work today and tomorrow."  }
]

# crawled user pids
# 'ex0v2' was changed to 'john'
arr = %w[
  3vfg
  1754
  bg0pe
  cpg
  eft
  750
  ex0v2
  pje
  i75
]

users = User.all
arr = []
users.each do |u|
  if Stripe::Customer.retrieve(id: u.stripe_customer_id).subscriptions.count > 1
    arr << [u.id,u.email]
  end
end

