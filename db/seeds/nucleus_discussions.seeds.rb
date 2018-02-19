Discussion.where(nucleus: true).delete_all

first_pass = [
    'After work',
    'Fund Raising & Capitalization',
    'Founders, staff, recruiting & advisors',
    'Everything else',
    'Legal, IP & corporate structure',
    'Marketing, growth & sales',
    'Product planning & design',
    'Recommendations needed and given',
    'Revenue & profitability',
    'Software & technology',
    'Time management & productivity',
    'Work/life balance'
]

nucleus_discussions = [
    'Business models & customer discovery',
    'Capitalization & cash flow',
    'Founders, team & advisors',
    'Ideation & validation',
    'Legal, IP & corporate structure',
    'Marketing, growth & sales',
    'Non-work & other topics',
    'Product planning & design',
    'Productivity hacks & time management',
    'Recommendations needed and given',
    'Revenue models & pricing',
    'Software & technology'
]

if Rails.env.production?
  author_id = User.where(email: 'john@startupalliance.com').pluck(:id).first
else
  author_id = 1
end

nucleus_discussions.each do |d|
  Discussion.create(name: d, nucleus: true, author_id: author_id)
end