Category.delete_all
categories = ["Activities & Fitness",
              "Arts & Culture",
              "Business & Entrepreneurship",
              "Careers & Workplace",
              "Climate & Nature",
              "Family & Friends",
              "Fashion & Wardrobe",
              "Food & Nutrition",
              "Health & Well Being",
              "Hobbies & Crafts",
              "Home & Garden",
              "Language & Communication",
              "Makers & Hacks",
              "Money",
              "Music",
              "Pets & Animals",
              "Photography",
              "Real Estate",
              "Relationships",
              "Retirement",
              "Sustainability",
              "Technology",
              "Transportation",
              "Travel"]
categories.each do |c|
  category = Category.new(name: c)
  category.save
end