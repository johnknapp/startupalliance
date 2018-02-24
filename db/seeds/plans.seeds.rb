plan = [
    'alliance_month',
    'company_month',
    'entrepreneur_year',
    'alliance_year',
    'company_year',
    'associate_year'
]

plan.each do |p|
  plan = Plan.where(name: p).first_or_initialize
  if plan.new_record?
    plan.save
  end
end

# See notes in traits seeds