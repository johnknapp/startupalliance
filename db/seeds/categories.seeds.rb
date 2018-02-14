Category.delete_all
cats = [
    'Advisors & mentors',
    'Analytics',
    'Blockchain',
    'Bootstrapping',
    'Business models',
    'Compensation, benefits & stock options',
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
    'Marketing, sales & business development',
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