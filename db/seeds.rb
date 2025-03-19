puts 'Creating admin user...'
Administrator.create_with(password: 'admin')
  .find_or_create_by!(name: 'admin')

# Clear existing data to prevent duplication when re-running seeds
puts 'Cleaning existing test data...'
Post.destroy_all
Label.destroy_all

# Create labels
puts 'Creating labels...'
labels = {
  technology: Label.create!(name: 'Technology'),
  lifestyle: Label.create!(name: 'Lifestyle'),
  travel: Label.create!(name: 'Travel'),
  food: Label.create!(name: 'Food'),
  programming: Label.create!(name: 'Programming'),
  design: Label.create!(name: 'Design'),
  health: Label.create!(name: 'Health')
}

puts 'Creating posts with different timestamps...'

# Helper method to create posts with specific timestamps
def create_post(title, content, created_at_time, labels_to_add)
  post = Post.new(
    title: title,
    content: content,
    visited_count: rand(10..100)
  )
  # Set the created_at timestamp
  post.created_at = created_at_time
  post.save!
  
  # Add labels to the post
  labels_to_add.each do |label|
    post.labels << label
  end
  
  puts "Created post: #{title} (#{created_at_time})"
  post
end

# Create posts created today
puts '- Creating posts from today...'
create_post(
  'Today\'s Tech News Roundup',
  "# Latest Technology Trends\n\nToday's technology highlights include advancements in AI and machine learning applications.\n\n## Key Points\n* New AI models released\n* Quantum computing breakthroughs\n* Tech stock market updates\n\nRead more for detailed analysis on these exciting developments.",
  Time.now,
  [labels[:technology], labels[:programming]]
)

create_post(
  'Healthy Breakfast Ideas for Busy Mornings',
  "# Quick and Nutritious Breakfast Ideas\n\nStart your day right with these simple yet healthy breakfast options perfect for busy professionals.\n\n## Recipe Ideas\n1. Overnight oats with berries\n2. Avocado toast with poached eggs\n3. Greek yogurt parfait\n\nThese recipes take less than 10 minutes to prepare and will keep you energized through the morning.",
  Time.now - 2.hours,
  [labels[:lifestyle], labels[:food], labels[:health]]
)

# Create posts from the last 3 days
puts '- Creating posts from last 3 days...'
create_post(
  'Weekend Getaway Planning Guide',
  "# How to Plan the Perfect Weekend Escape\n\nNeed a break from routine? Here's how to plan a refreshing weekend getaway without breaking the bank.\n\n## Planning Steps\n* Choose destinations within driving distance\n* Find accommodation deals\n* Create a flexible itinerary\n\nRemember that sometimes the best trips are the spontaneous ones!",
  2.days.ago,
  [labels[:travel], labels[:lifestyle]]
)

create_post(
  'Modern UI Design Principles',
  "# Effective UI Design for 2023\n\nExploring the latest principles that make user interfaces both beautiful and functional.\n\n## Design Elements to Consider\n* Minimalist navigation\n* Accessibility features\n* Dark mode optimization\n* Responsive layouts\n\nThe best designs combine aesthetics with intuitive user experiences.",
  3.days.ago - 5.hours,
  [labels[:design], labels[:technology]]
)

# Create posts from the last month
puts '- Creating posts from last month...'
create_post(
  'Programming Language Comparison',
  "# Choosing the Right Programming Language\n\nComparing popular programming languages for different types of projects and career paths.\n\n## Languages Covered\n* Python vs. JavaScript\n* Rust vs. Go\n* Java vs. Kotlin\n\nThe right choice depends on your specific project requirements and team expertise.",
  20.days.ago,
  [labels[:programming], labels[:technology]]
)

create_post(
  'Summer Travel Destinations',
  "# Top 10 Summer Destinations\n\nDiscover amazing places to visit this summer, from beach resorts to mountain retreats.\n\n## Featured Destinations\n* Mediterranean coastal towns\n* National parks of North America\n* Southeast Asian islands\n\nStart planning early to get the best deals on flights and accommodations.",
  25.days.ago,
  [labels[:travel]]
)

# Create older posts
puts '- Creating older posts...'
create_post(
  'Building a Personal Fitness Routine',
  "# Customized Fitness Plans That Work\n\nLearn how to create an exercise routine that fits your schedule and helps you achieve your health goals.\n\n## Fitness Components\n* Strength training basics\n* Cardio options for all levels\n* Flexibility and mobility work\n* Rest and recovery importance\n\nConsistency is more important than intensity when starting a new fitness journey.",
  2.months.ago,
  [labels[:health], labels[:lifestyle]]
)

create_post(
  'Beginner\'s Guide to Web Development',
  "# Starting Your Web Development Journey\n\nA comprehensive guide for absolute beginners interested in learning web development.\n\n## Learning Path\n* HTML fundamentals\n* CSS styling techniques\n* JavaScript basics\n* Frontend frameworks introduction\n\nFollow this path and build projects along the way to reinforce your learning.",
  3.months.ago,
  [labels[:programming], labels[:technology], labels[:design]]
)

puts 'Seed data created successfully!'