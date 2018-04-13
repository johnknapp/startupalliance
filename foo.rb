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


