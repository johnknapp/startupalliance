params = {"utf8"=>"✓", "authenticity_token"=>"r+8wGCDx4XsWQKKitoc+y89r2AfA5pN41Onw/sXj+bBwRG/UfwSeQg8s8CJb5WWJKlKFciYcSzxFZoh3eenGAw==", "user"=>{"acqsrc"=>"home_page", "plan_id"=>"5", "email"=>""}, "g-recaptcha-response"=>"", "stripeToken"=>"tok_1BqppOG82GK6HBTxOSR9Ug7B", "stripeTokenType"=>"card", "stripeEmail"=>"foodie@bar.com"}

Company.all.each do |c|
  c.update(webmeet_code:  Generator.code(6))
end

Alliance.all.each do |a|
  a.update(webmeet_code:  Generator.code(6))
end

