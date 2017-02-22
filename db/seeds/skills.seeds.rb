skills = [
  'Collaboration',
  'Communication',
  'Delegation',
  'Design',
  'Finance',
  'Engineering',
  'Fundraising',
  'Leadership',
  'Marketing',
  'Negotiation',
  'Operations',
  'Partnerships',
  'Product Mgmt.',
  'Recruiting',
  'Sales',
  'Strategy',
  'Time Mgmt.',
  'UX / UI'
]

skills.each do |s|
  skill = Skill.where(name: s).first_or_initialize
  if skill.new_record?
    skill.save
  end
end

# See notes in traits seeds
