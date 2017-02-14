Skill.destroy_all

skills = [
  'Design',
  'Finance',
  'Engineering',
  'Fundraising',
  'Leadership',
  'Marketing',
  'Operations',
  'Partnerships',
  'Product Management',
  'Recruiting',
  'Sales',
  'Strategy',
  'UX / UI'
]

skills.each do |s|
  Skill.create(name: s)
end
