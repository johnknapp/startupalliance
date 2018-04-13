plan = %w[
  company_year
  alliance_year
  entrepreneur_year
  company_month
  alliance_month
  entrepreneur_month
  associate_year
]

plan.each do |p|
  plan = Plan.where(name: p).first_or_initialize
  if plan.new_record?
    plan.save
  end
end

# See notes in traits seeds