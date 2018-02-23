content = [
  {        name: "Business models & customer discovery",
    description: "What you sell, how you sell it and how you get to product/market fit." },
  {        name: "Capitalization & cash flow",
    description: "Raising money, achieving profitability and controlling costs." },
  {        name: "Founders, team & advisors",
    description: "Success demands the right people doing the right things." },
  {        name: "Ideation & validation",
    description: "Coming up with a great idea, turning it into a real business and making sure it’s viable." },
  {        name: "Legal, IP & corporate structure",
    description: "Contracts, Agreements, Patents & Trademarks and business formation." },
  {        name: "Marketing, growth & sales",
    description: "Positioning, messaging, growth hacks, analytics, advertising, funnels and strategic partnerships." },
  {        name: "Non-work & other topics",
    description: "Member introductions, work/life balance, sustainability and everything else entrepreneurs care about." },
  {        name: "Product planning, production & design",
    description: "Bringing a great product to market takes more than a good idea and fresh design." },
  {        name: "Productivity hacks & time management",
    description: "Tips, tricks and tools for getting your work done on time and keeping your priorities straight." },
  {        name: "Requests and recommendations ",
    description: "Know a great attorney? Looking for office space? Need a good PR firm?" },
  {        name: "Revenue models & pricing",
    description: "How you provide value to customers and how you price your products and services." },
  {        name: "Software, engineering & technology",
    description: "The tools and tech you love, the processes and strategies you employ. What works and what doesn’t." }
]

if Rails.env.production?
  author_id = User.where(email: 'john@startupalliance.com').pluck(:id).first
else
  author_id = 1
end

content.each do |item|
  disco = Discussion.where(name: item[:name], description: item[:description], nucleus: true, author_id: author_id).first_or_initialize
  if disco.new_record?
    disco.save
  end
end