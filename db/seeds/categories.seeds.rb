Category.delete_all

#
# Do not use commas, they parse as separate tags!
#

cats = [
    'Advisors & mentors',
    'Analytics',
    'Benefits & stock options',
    # 'Blockchain',
    'Bootstrapping',
    'Business models & customer discovery',
    'Compensation & payroll',
    # 'Customer discovery',
    # 'Design',
    # 'Developers',
    'Entrepreneurship',
    # 'Equity',
    # 'Experiments',
    # 'Finance',
    'Founders & equity',
    'Funding & Capitalization',
    'Growth & customer acquisition',
    'Ideation & validation',
    # 'Internationalization',
    # 'Launch',
    'Leadership',
    'Lean startup',
    'Legal & intellectual property',
    'Marketing & sales',
    'Miscellaneous',
    # 'Online advertising',
    'Offices & co-working',
    # 'Operations',
    # 'Other',
    # 'Partnerships',
    # 'Planning',
    # 'Pricing',
    'Problem/Solution fit',
    'Product/Market fit',
    'Product management',
    'Productivity hacks & time management',
    # 'Recruiting',
    'User onboarding & retention',
    'Revenue models & pricing',
    # 'Sales & business development',
    'Software engineering & developers',
    'Strategic partnerships & business development',
    # 'Sustainability',
    'Team building & staffing',
    'Technology & IT',
    'Tools & infrastructure',
    'UX/UI & design'
    # 'Work/Life balance'
]
cats.each do |c|
  Category.create(name: c)
end