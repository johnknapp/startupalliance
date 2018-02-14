Category.delete_all


#
# Do not use commas, they'll parse as separate tags!
#


cats = [
    'Advisors & mentors',
    'Analytics',
    'Benefits & stock options',
    'Blockchain',
    'Bootstrapping',
    'Business models',
    'Compensation',
    'Customer discovery',
    'Design',
    'Developers',
    'Entrepreneurship',
    'Equity',
    'Experiments',
    'Finance',
    'Founders',
    'Funding & Capitalization',
    'Growth & customer acquisition',
    'Ideation',
    'Internationalization',
    'Launch',
    'Leadership',
    'Lean startup',
    'Legal & intellectual property',
    'Marketing',
    'Miscellaneous',
    'Online advertising',
    'Offices & co-working',
    'Operations',
    'Other',
    'Partnerships',
    'Planning',
    'Pricing',
    'Problem/Solution fit',
    'Product/Market fit',
    'Product management',
    'Productivity',
    'Recruiting',
    'Retention & onboarding',
    'Revenue models',
    'Sales & business development',
    'Software engineering',
    'Strategic partnerships',
    'Sustainability',
    'Team & personnel',
    'Technology & IT',
    'Tools & infrastructure',
    'UX/UI',
    'Work/Life balance'
]
cats.each do |c|
  Category.create(name: c)
end