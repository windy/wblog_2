require 'securerandom'

WORDS = %w[apple banana cherry date fig grape kiwi lemon mango orange pear plum strawberry watermelon].freeze

namespace :test_data do
  desc "Generate test data for timeline filtering feature"
  task generate: :environment do
    puts "Generating test data for timeline filtering feature..."

    # Create labels
    puts "Creating labels..."
    labels = [
      { name: "技术", color: "#3498db" },
      { name: "生活", color: "#2ecc71" },
      { name: "旅行", color: "#f39c12" },
      { name: "阅读", color: "#9b59b6" },
      { name: "工作", color: "#e74c3c" },
      { name: "音乐", color: "#1abc9c" },
      { name: "电影", color: "#e67e22" },
      { name: "美食", color: "#d35400" }
    ]

    created_labels = []
    labels.each do |label_attrs|
      label = Label.find_or_create_by(name: label_attrs[:name])
      label.update(color: label_attrs[:color]) if label.respond_to?(:color)
      created_labels << label
      puts "  - Created label: #{label.name}"
    end

    # Sample content templates with markdown formatting
    markdown_templates = [
      {
        title_prefix: "技术笔记：",
        content_template: "# %{title}\n\n这是一篇关于技术的文章。\n\n## 主要内容\n\n* 第一点\n* 第二点\n* 第三点\n\n```ruby\ndef hello_world\n  puts \"Hello, World!\"\nend\n```\n\n> 这是一段引用内容\n\n详细内容请参考[相关链接](https://example.com)"
      },
      {
        title_prefix: "生活随笔：",
        content_template: "# %{title}\n\n## 今日感悟\n\n今天是美好的一天，我做了以下几件事：\n\n1. 晨跑5公里\n2. 读了30页书\n3. 学习了新技术\n\n![示例图片](https://example.com/image.jpg)\n\n**重要提醒**：保持规律作息很重要！"
      },
      {
        title_prefix: "旅行日记：",
        content_template: "# %{title}\n\n## 旅行计划\n\n### 行程安排\n\n| 日期 | 地点 | 活动 |\n| ---- | ---- | ---- |\n| 周一 | 北京 | 参观故宫 |\n| 周二 | 上海 | 外滩漫步 |\n| 周三 | 杭州 | 西湖游船 |\n\n*期待这次旅行带来的美好回忆！*"
      },
      {
        title_prefix: "读书笔记：",
        content_template: "# %{title}\n\n这本书主要讲述了一个关于成长的故事。\n\n## 精彩片段\n\n> 人的一生就是一场修行\n\n## 心得体会\n\n通过阅读这本书，我领悟到了以下几点：\n\n1. 坚持很重要\n2. 学会放下\n3. 感恩生活\n\n***\n\n这是我今年读的第5本书，希望能达成年度读书目标。"
      }
    ]

    # Create posts from different time periods
    time_periods = [
      { name: "最近一个月内", start_date: 1.month.ago, end_date: Time.now, count: 5 },
      { name: "最近半年内", start_date: 6.months.ago, end_date: 1.month.ago - 1.day, count: 8 },
      { name: "最近一年内", start_date: 1.year.ago, end_date: 6.months.ago - 1.day, count: 10 },
      { name: "两到三年前", start_date: 3.years.ago, end_date: 1.year.ago - 1.day, count: 7 }
    ]

    puts "\nCreating posts..."
    post_count = 0

    def generate_random_title(num_words = 3)
      WORDS.sample(num_words).join(' ')
    end

    time_periods.each do |period|
      puts "  Creating #{period[:count]} posts for period: #{period[:name]}"
      
      period[:count].times do |i|
        # Select random template and generate title
        template = markdown_templates.sample
        title_suffix = "#{generate_random_title(3)} ##{i+1}"
        title = "#{template[:title_prefix]}#{title_suffix}"
        
        # Generate content from template
        content = template[:content_template] % { title: title_suffix }
        
        # Create post with random date in the period
        random_date = rand(period[:start_date]..period[:end_date])
        
        # Randomly enable voting for some posts
        enable_voting = [true, false].sample
        
        # Create the post
        post = Post.new(
          title: title,
          content: content,
          created_at: random_date,
          updated_at: random_date,
          enable_voting: enable_voting
        )
        
        # Save with validation disabled to allow backdating
        if post.save(validate: false)
          # Assign 1-3 random labels
          post.labels = created_labels.sample(rand(1..3))
          post.save(validate: false)
          
          # Add some random likes
          rand(0..15).times do
            post.likes.create
          end
          
          # Add some random votes if enabled
          if enable_voting
            rand(0..20).times do
              vote_type_options = ['excellent', 'normal', 'poor']
              vote_type = vote_type_options.sample
              session_id = SecureRandom.uuid
              post.votes.create(vote_type: vote_type, session_id: session_id)
            end
          end
          
          post_count += 1
          print "."
        else
          print "x"
        end
      end
      puts
    end

    puts "\nSuccessfully created #{post_count} posts with various labels and time periods."
    puts "Test data generation completed!"
  end

  desc "Clear all test data"
  task clear: :environment do
    puts "Clearing test data..."
    
    # Only delete posts that were created by this rake task
    # This is safer than deleting all posts
    confirm = ENV['CONFIRM']
    
    unless confirm == 'YES'
      puts "This will delete all posts, comments, likes, and votes in the database."
      puts "To confirm, run the task with CONFIRM=YES"
      puts "Example: rake test_data:clear CONFIRM=YES"
      exit
    end
    
    Post.destroy_all
    puts "Deleted all posts and associated comments, likes, and votes."
    
    Label.destroy_all
    puts "Deleted all labels."
    
    puts "Test data cleared successfully."
  end
end