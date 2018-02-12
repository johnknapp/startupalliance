Category.delete_all
cats = [
    'Accounting',
    'Business development',
    'Design',
    'Finance',
    'Funding',
    'Growth',
    'Leadership',
    'Legal',
    'Marketing',
    'Operations',
    'Partnerships',
    'Product/Market fit',
    'Product Mgmt.',
    'Productivity',
    'Recruiting',
    'Strategy',
    'UX/UI',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    ''
]
cats.each do |c|
  Category.create(name: c) unless c.nil?
end