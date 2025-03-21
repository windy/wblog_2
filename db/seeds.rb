# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

# Clear existing data
puts 'Clearing existing data...'
Like.delete_all
Vote.delete_all
Comment.delete_all
Post.all.each { |post| post.labels.clear } # Clear associations
Post.delete_all
Label.delete_all

# Keep existing administrators
puts 'Creating admin user...'
Administrator.create_with(password: 'admin')
  .find_or_create_by!(name: 'admin')

# Create labels
puts 'Creating labels...'
labels = {
  tech: Label.create!(name: 'Technology'),
  ruby: Label.create!(name: 'Ruby'),
  rails: Label.create!(name: 'Rails'),
  js: Label.create!(name: 'JavaScript'),
  life: Label.create!(name: 'Life'),
  travel: Label.create!(name: 'Travel'),
  food: Label.create!(name: 'Food'),
  books: Label.create!(name: 'Books'),
  music: Label.create!(name: 'Music')
}

# Create sample posts with different time ranges
puts 'Creating posts...'

# Helper method to create posts with specific attributes
def create_post(title:, content:, created_at:, visited_count:, labels:, likes_count:, enable_voting:)
  # Create post with specified attributes
  post = Post.create!(
    title: title,
    content: content,
    created_at: created_at,
    updated_at: created_at,
    visited_count: visited_count,
    enable_voting: enable_voting
  )

  # Associate labels
  post.labels = labels

  # Create likes
  likes_count.times do |i|
    Like.create!(
      post: post,
      created_at: post.created_at + rand(1..30).days
    )
  end

  # Create votes for votable posts
  if enable_voting
    vote_types = [:excellent, :normal, :poor]
    vote_distribution = [rand(5..20), rand(3..15), rand(0..5)]
    
    vote_types.each_with_index do |type, index|
      vote_distribution[index].times do |i|
        Vote.create!(
          post: post,
          vote_type: type,
          session_id: "seed-vote-#{post.id}-#{type}-#{i}",
          created_at: post.created_at + rand(1..14).days
        )
      end
    end
  end

  post
end

# Sample content template
markdown_template = <<~MARKDOWN
  # %{title}

  This is a sample post about %{topic}.

  ## Introduction

  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod, nisi vel consectetur interdum, nisl nunc egestas nisi, euismod aliquam nisl nunc egestas nisi.

  ## Main Content

  %{content}

  ```ruby
  def hello_world
    puts "Hello, World!"
  end
  ```

  ## Conclusion

  Thanks for reading this post about %{topic}!

  - Point 1
  - Point 2
  - Point 3
MARKDOWN

# Content variations for different post topics
content_variations = {
  tech: "Technology is constantly evolving, and it's important to stay updated with the latest trends. In this post, we'll explore some of the most exciting developments in the tech world.",
  ruby: "Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.",
  rails: "Ruby on Rails is a web application framework written in Ruby. It follows the Model-View-Controller (MVC) pattern and emphasizes Convention over Configuration (CoC) and Don't Repeat Yourself (DRY) principles.",
  js: "JavaScript is a programming language that conforms to the ECMAScript specification. JavaScript is high-level, often just-in-time compiled, and multi-paradigm.",
  life: "Life is a journey filled with ups and downs. It's important to find balance and enjoy the small moments that make life beautiful.",
  travel: "Traveling opens your mind to new experiences and cultures. It helps you grow as a person and gain a new perspective on life.",
  food: "Food is not just about sustenance; it's about culture, tradition, and bringing people together. Exploring different cuisines can be an adventure in itself.",
  books: "Books are a gateway to different worlds and perspectives. They allow us to experience things we might never encounter in our daily lives.",
  music: "Music has the power to evoke emotions and memories. It transcends language barriers and connects people from all walks of life."
}

# Create posts from last month (1-30 days ago)
10.times do |i|
  topic = labels.keys.sample
  title = "Recent Post #{i+1}: #{topic.to_s.capitalize} Insights"
  content = markdown_template % {
    title: title,
    topic: topic.to_s,
    content: content_variations[topic]
  }
  
  create_post(
    title: title,
    content: content,
    created_at: rand(1..30).days.ago,
    visited_count: rand(50..500),
    labels: [labels[topic], labels.values.sample],
    likes_count: rand(0..15),
    enable_voting: [true, false].sample
  )
end

# Create posts from last 3 months (31-90 days ago)
15.times do |i|
  topic = labels.keys.sample
  title = "Quarter Post #{i+1}: Exploring #{topic.to_s.capitalize}"
  content = markdown_template % {
    title: title,
    topic: topic.to_s,
    content: content_variations[topic]
  }
  
  create_post(
    title: title,
    content: content,
    created_at: rand(31..90).days.ago,
    visited_count: rand(100..1500),
    labels: [labels[topic], labels.values.sample],
    likes_count: rand(5..30),
    enable_voting: [true, false].sample
  )
end

# Create posts from last 3 years (91 days to 3 years ago)
25.times do |i|
  topic = labels.keys.sample
  title = "Archive Post #{i+1}: The World of #{topic.to_s.capitalize}"
  content = markdown_template % {
    title: title,
    topic: topic.to_s,
    content: content_variations[topic]
  }
  
  create_post(
    title: title,
    content: content,
    created_at: rand(91..1095).days.ago,
    visited_count: rand(500..5000),
    labels: [labels[topic], labels.values.sample, labels.values.sample],
    likes_count: rand(10..50),
    enable_voting: [true, false].sample
  )
end

# Create a few high-traffic posts
3.times do |i|
  topic = labels.keys.sample
  title = "Popular Post #{i+1}: Ultimate Guide to #{topic.to_s.capitalize}"
  content = markdown_template % {
    title: title,
    topic: topic.to_s,
    content: content_variations[topic] * 3 # Longer content
  }
  
  create_post(
    title: title,
    content: content,
    created_at: rand(1..500).days.ago,
    visited_count: rand(1000..10000),
    labels: labels.values.sample(3),
    likes_count: rand(30..100),
    enable_voting: true
  )
end

puts "Seeding completed successfully!"
puts "Created #{Post.count} posts with #{Label.count} labels"
puts "Added #{Like.count} likes and #{Vote.count} votes"