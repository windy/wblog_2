puts 'Creating admin user...'
Administrator.create_with(password: 'admin')
  .find_or_create_by!(name: 'admin')

# To reset the database and run seed data:
# rails db:reset           # Runs db:drop db:setup
# rails db:setup           # Runs db:create db:schema:load db:seed
# rails db:seed            # Just runs the seed data

# Create test labels
puts 'Creating test labels...'
labels = [
  'Technology', 'Programming', 'Ruby', 'Rails', 'JavaScript',
  'Frontend', 'Backend', 'Database', 'DevOps', 'Testing',
  'Career', 'Life', 'Productivity'
]

created_labels = labels.map do |label_name|
  Label.find_or_create_by!(name: label_name)
end

# Helper to create random datetime within a range
def random_date_between(start_date, end_date)
  start_date + rand(end_date - start_date)
end

# Create test posts with varying stats for sorting test
puts 'Creating test posts with different timestamps, likes and visits...'

# Content templates for posts
content_templates = [
  "# %{title}\n\nThis is a sample blog post about %{topic}.\n\n## Key Points\n\n* Point one about %{topic}\n* Point two about %{topic}\n* Point three about %{topic}\n\n```ruby\nputs 'Hello World'\n```",
  "# %{title}\n\nLet me share my thoughts on %{topic}.\n\n## Introduction\n\nThe concept of %{topic} has been around for a while.\n\n## Details\n\nHere are some details about %{topic}.\n\n## Conclusion\n\n%{topic} is a fascinating subject.",
  "# %{title}\n\n%{topic} is an interesting area to explore.\n\n## Background\n\nThe history of %{topic} dates back many years.\n\n## Current Trends\n\nNowadays, %{topic} is evolving rapidly.\n\n## Future\n\nThe future of %{topic} looks promising."
]

post_data = [
  { title: "Getting Started with Ruby on Rails", labels: ["Ruby", "Rails", "Programming"], likes: 45, visits: 230, voting: true },
  { title: "Advanced JavaScript Techniques", labels: ["JavaScript", "Frontend", "Programming"], likes: 38, visits: 195, voting: true },
  { title: "Database Optimization Tips", labels: ["Database", "Backend", "Performance"], likes: 22, visits: 145, voting: false },
  { title: "The Future of Web Development", labels: ["Frontend", "Technology", "Career"], likes: 56, visits: 320, voting: true },
  { title: "Test-Driven Development in Practice", labels: ["Testing", "Programming", "DevOps"], likes: 17, visits: 120, voting: false },
  { title: "RESTful API Design Principles", labels: ["Backend", "Programming", "API"], likes: 31, visits: 210, voting: false },
  { title: "Deploying Rails Apps with Docker", labels: ["Rails", "DevOps", "Docker"], likes: 29, visits: 180, voting: true },
  { title: "Frontend Framework Comparison", labels: ["JavaScript", "Frontend", "Technology"], likes: 42, visits: 245, voting: false },
  { title: "Managing Technical Debt", labels: ["Career", "Programming", "DevOps"], likes: 25, visits: 165, voting: true },
  { title: "Work-Life Balance for Developers", labels: ["Life", "Career", "Productivity"], likes: 51, visits: 275, voting: false },
  { title: "Introduction to GraphQL", labels: ["API", "Frontend", "Backend"], likes: 33, visits: 190, voting: true },
  { title: "Automated Testing Strategies", labels: ["Testing", "DevOps", "Programming"], likes: 19, visits: 135, voting: false },
  { title: "SQL Performance Tuning", labels: ["Database", "Performance", "Backend"], likes: 27, visits: 175, voting: true },
  { title: "Learning React from Scratch", labels: ["JavaScript", "Frontend", "React"], likes: 40, visits: 235, voting: false },
  { title: "Career Growth in Tech Industry", labels: ["Career", "Life", "Technology"], likes: 36, visits: 205, voting: true }
]

# Create posts
start_date = 6.months.ago
end_date = Time.now

post_data.each_with_index do |data, index|
  # Determine creation date - spread posts over the last 6 months
  created_at = random_date_between(start_date, end_date)
  
  # Select random content template and populate
  template = content_templates.sample
  topic = data[:labels].sample
  content = template % { title: data[:title], topic: topic }
  
  # Create post with specified attributes
  post = Post.find_or_create_by(title: data[:title]) do |p|
    p.content = content
    p.created_at = created_at
    p.updated_at = created_at
    p.visited_count = data[:visits]
    p.enable_voting = data[:voting]
    
    # Find and attach labels
    label_objects = data[:labels].map do |label_name|
      Label.find_or_create_by!(name: label_name)
    end
    p.labels = label_objects
  end
  
  # Create likes for the post
  data[:likes].times do
    Like.create(post: post) unless Like.where(post_id: post.id).count >= data[:likes]
  end
  
  # Create votes for posts with voting enabled
  if data[:voting]
    vote_distribution = {
      excellent: rand(5..15),
      normal: rand(10..25),
      poor: rand(0..10)
    }
    
    vote_distribution.each do |type, count|
      count.times do |i|
        Vote.create(
          post: post,
          vote_type: type,
          session_id: "test-session-#{post.id}-#{type}-#{i}"
        )
      end
    end
  end
  
  puts "Created post: #{data[:title]} with #{data[:likes]} likes and #{data[:visits]} visits"
end

puts "Seed completed successfully!"