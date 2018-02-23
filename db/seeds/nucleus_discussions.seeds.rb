#
# tweak name and description and re-seed but don't change the slug!
#

content = [
  {        name: "Business models & customer discovery",
    description: "What you sell, how you sell it and how you get to product/market fit.", 
            slug:  "business-models" },
  {        name: "Capitalization & cash flow",
    description: "Raising money, achieving profitability and controlling costs.",
            slug:  "capitalization" },
  {        name: "Founders, team & advisors",
    description: "Success demands the right people doing the right things.",
            slug:  "people" },
  {        name: "Ideation & validation",
    description: "Coming up with a great idea, turning it into a real business and making sure it’s viable.",
            slug:  "ideation" },
  {        name: "Legal, IP & corporate structure",
    description: "Contracts, Agreements, Patents & Trademarks and business formation.",
            slug:  "legal" },
  {        name: "Marketing, growth & sales",
    description: "Positioning, messaging, growth hacks, analytics, advertising, funnels and strategic partnerships.",
            slug:  "marketing" },
  {        name: "Non-work & other topics",
    description: "Member introductions, work/life balance, sustainability and everything else entrepreneurs care about.",
            slug:  "non-work" },
  {        name: "Product planning, production & design",
    description: "Bringing a great product to market takes more than a good idea and fresh design.",
            slug:  "product" },
  {        name: "Productivity hacks & time management",
    description: "Tips, tricks and tools for getting your work done on time and keeping your priorities straight.",
            slug:  "productivity" },
  {        name: "Requests and recommendations ",
    description: "Know a great attorney? Looking for office space? Need a good PR firm?",
            slug:  "recommendations" },
  {        name: "Revenue models & pricing",
    description: "How you provide value to customers and how you price your products and services.",
            slug:  "revenue" },
  {        name: "Software, engineering & technology",
    description: "The tools and tech you love, the processes and strategies you employ. What works and what doesn’t.",
            slug:  "technology" }
]

if Rails.env.production?
  author_id = User.where(email: 'john@startupalliance.com').pluck(:id).first
else
  author_id = 1
end

content.each do |item|
  disco = Discussion.where(slug: item[:slug]).first_or_initialize
  if disco.new_record?
    disco.name          = item[:name]
    disco.description   = item[:description]
    disco.nucleus       = true
    disco.author_id     = author_id
    disco.save
  end
end
