plan = [
    'alliance_month',
    'company_month',
    'jet_fuel_year',
    'alliance_year',
    'company_year',
    'free_year'
]

plan.each do |p|
  plan = Plan.where(name: p).first_or_initialize
  if plan.new_record?
    plan.save
  end
end

# See notes in traits seeds