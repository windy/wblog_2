# This file contains all the record creation needed to seed the database with default values.
# The data can be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Clear existing data before seeding
puts 'Cleaning database...'
Vote.destroy_all
Like.destroy_all
Comment.destroy_all
Post.all.each { |post| post.labels.clear }
Post.destroy_all
Label.destroy_all
Administrator.destroy_all
puts 'Database cleaned!'

# Create administrator account
puts 'Creating admin user...'
Administrator.create_with(password: 'admin')
  .find_or_create_by!(name: 'admin')

# Create blog labels/categories
puts 'Creating labels...'
labels = [
  'Ruby',
  'Rails',
  'JavaScript',
  'CSS',
  'HTML',
  'Database',
  'DevOps',
  'Testing',
  'Security',
  'Performance'
].map do |name|
  Label.create!(name: name)
end

# Create blog posts
puts 'Creating posts...'
posts = [
  {
    title: 'Getting Started with Ruby on Rails',
    content: <<~CONTENT
      # Introduction to Rails
      
      Ruby on Rails is a web application framework that includes everything needed to create database-backed web applications according to the Model-View-Controller (MVC) pattern.

      ## Setting up your development environment

      First, make sure you have Ruby installed:
      
      ```
      ruby -v
      ```

      Then install Rails:
      
      ```
      gem install rails
      ```

      ## Creating your first Rails application
      
      Let's create a new Rails application:
      
      ```
      rails new myblog
      cd myblog
      ```

      Now you can start the Rails server:
      
      ```
      rails server
      ```
      
      Visit http://localhost:3000 in your browser to see your new Rails application!
    CONTENT
  },
  {
    title: 'Advanced ActiveRecord Techniques',
    content: <<~CONTENT
      # Mastering ActiveRecord
      
      ActiveRecord is Rails' ORM (Object-Relational Mapping) system that lets you interact with your database in a simple way.
      
      ## Complex Queries with ActiveRecord
      
      Here's how you can build complex queries with ActiveRecord:
      
      ```ruby
      users = User.where(active: true)
                  .where('last_login > ?', 1.month.ago)
                  .includes(:posts)
                  .order('created_at DESC')
      ```
      
      ## Using Scopes
      
      Scopes let you define commonly-used queries that can be referenced as method calls:
      
      ```ruby
      class User < ApplicationRecord
        scope :active, -> { where(active: true) }
        scope :inactive, -> { where(active: false) }
        scope :recent, -> { where('created_at > ?', 1.week.ago) }
      end
      ```
      
      Now you can use these scopes in your queries:
      
      ```ruby
      User.active.recent
      ```
    CONTENT
  },
  {
    title: 'The Magic of JavaScript Promises',
    content: <<~CONTENT
      # Understanding JavaScript Promises
      
      Promises are a pattern that helps with asynchronous operations in JavaScript.
      
      ## Basic Promise Usage
      
      Here's how to create and use a simple Promise:
      
      ```javascript
      const myPromise = new Promise((resolve, reject) => {
        // Asynchronous operation
        const success = true;
        
        if (success) {
          resolve('Operation completed successfully!');
        } else {
          reject('Operation failed!');
        }
      });
      
      myPromise
        .then(result => {
          console.log(result);
        })
        .catch(error => {
          console.error(error);
        });
      ```
      
      ## Chaining Promises
      
      One of the most powerful features of Promises is the ability to chain them:
      
      ```javascript
      fetchData()
        .then(processData)
        .then(saveData)
        .then(() => {
          console.log('All done!');
        })
        .catch(error => {
          console.error('Something went wrong:', error);
        });
      ```
    CONTENT
  },
  {
    title: 'CSS Grid Layout Made Simple',
    content: <<~CONTENT
      # CSS Grid Layout
      
      CSS Grid Layout is a powerful layout system available in CSS that makes designing web page layouts much easier.
      
      ## Basic Grid Layout
      
      Here's how to create a simple grid layout:
      
      ```css
      .container {
        display: grid;
        grid-template-columns: 1fr 2fr 1fr;
        grid-gap: 20px;
      }
      ```
      
      ## Responsive Grid with minmax()
      
      You can create responsive grids without media queries using `minmax()`:
      
      ```css
      .container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        grid-gap: 20px;
      }
      ```
      
      This will create as many columns as can fit with a minimum width of 200px.
    CONTENT
  },
  {
    title: 'Database Performance Optimization Techniques',
    content: <<~CONTENT
      # Optimizing Database Performance
      
      Database performance is critical for application speed and user experience.
      
      ## Indexing Strategies
      
      Proper indexing is one of the most effective ways to improve database performance:
      
      ```sql
      CREATE INDEX index_users_on_email ON users (email);
      ```
      
      In Rails, you can add indexes in your migrations:
      
      ```ruby
      add_index :users, :email, unique: true
      ```
      
      ## Query Optimization
      
      Inefficient queries can significantly slow down your application. Here are some tips for optimization:
      
      1. Select only the columns you need
      2. Use JOINs appropriately
      3. Avoid N+1 query problems
      4. Use EXPLAIN to analyze query performance
      
      ## Connection Pooling
      
      Configure your connection pool size based on your application's needs:
      
      ```ruby
      # config/database.yml
      production:
        pool: 25
      ```
    CONTENT
  }
]

created_posts = posts.map do |post_attrs|
  post = Post.create!(
    title: post_attrs[:title],
    content: post_attrs[:content],
    visited_count: rand(100..1000),
    enable_voting: [true, false].sample # Randomly enable voting for some posts
  )
  
  # Associate 2-3 random labels with each post
  post.labels << labels.sample(rand(2..3))
  post
end

# Create a couple of posts with voting enabled specifically
voting_post = Post.create!(
  title: 'What is your favorite programming language?',
  content: "# Programming Language Survey\n\nWe'd like to know which programming language you prefer.\n\nPlease vote using the voting options below!\n\n## Languages to consider\n\n* Ruby\n* Python\n* JavaScript\n* Go\n* Rust",
  visited_count: rand(500..2000),
  enable_voting: true
)
voting_post.labels << labels.sample(2)

# Create comments for posts
puts 'Creating comments...'
user_names = ['Alice', 'Bob', 'Charlie', 'David', 'Eva', 'Frank', 'Grace', 'Hannah']
domains = ['gmail.com', 'outlook.com', 'yahoo.com', 'example.com']

created_posts.each do |post|
  # Create 3-7 comments per post
  rand(3..7).times do
    name = user_names.sample
    domain = domains.sample
    Comment.create!(
      post: post,
      name: name,
      email: "#{name.downcase}@#{domain}",
      content: [
        "Great article! Thanks for sharing.",
        "I found this very helpful. Looking forward to more content like this.",
        "Interesting perspective. Have you considered exploring the topic of #{labels.sample.name} as well?",
        "This answered many questions I had about #{post.title.split.sample}.",
        "Could you elaborate more on the #{post.content.split("\n").sample.split.sample(3).join(' ')} part?",
        "I've been working with this technology for years and still learned something new!",
        "I disagree with some points, particularly about #{post.content.split('##').last.split("\n").first if post.content.include?('##')}",
        "Bookmarked for future reference. Very comprehensive!"
      ].sample
    )
  end
end

# Create likes for posts
puts 'Creating likes...'
created_posts.each do |post|
  # Create 5-20 likes per post
  rand(5..20).times do
    Like.create!(post: post)
  end
end

# Create votes for votable posts
puts 'Creating votes...'
Post.votable.each do |post|
  # Create 10-30 votes per votable post
  rand(10..30).times do
    # Generate a random session id
    session_id = SecureRandom.hex(16)
    
    # Create a vote with a random type
    Vote.create!(
      post: post,
      vote_type: Vote.vote_types.keys.sample,
      session_id: session_id
    )
  end
end

puts 'Seed data has been created successfully!'
puts '--------------------------------------------------'
puts 'Admin login:'
puts "Username: admin"
puts "Password: admin"
puts '--------------------------------------------------'
puts "Created #{Label.count} labels"
puts "Created #{Post.count} posts"
puts "Created #{Comment.count} comments"
puts "Created #{Like.count} likes"
puts "Created #{Vote.count} votes"
puts '--------------------------------------------------'
puts 'You can now start your server with: rails server'