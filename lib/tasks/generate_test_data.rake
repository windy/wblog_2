namespace :blog do
  desc "Generate test blog posts and likes for different time periods and like counts"
  task :generate_test_data => :environment do
    puts "Starting to generate test blog posts and likes..."

    # Define periods for post creation
    periods = {
      "1 Month" => 1.month.ago,
      "3 Months" => 3.months.ago,
      "1 Year" => 1.year.ago,
      "3 Years" => 3.years.ago
    }

    # Define like counts to generate
    like_counts = [12, 55, 120]

    # Generate test posts for each period
    periods.each do |period_name, time|
      puts "\nGenerating posts for #{period_name} period..."
      
      # Create 3 posts for each period
      3.times do |i|
        title = "Test Post - #{period_name} - #{i + 1}"
        content = generate_content(period_name, i)
        
        # Create post with timestamp in the specified period
        post = Post.new(
          title: title,
          content: content,
          created_at: rand(time..Time.current),
          updated_at: Time.current,
          visited_count: rand(100..500)
        )
        
        if post.save
          puts "  Created post: #{title}"
          
          # Add likes to the post
          like_count = like_counts[i % like_counts.length]
          puts "  Adding #{like_count} likes to post..."
          
          like_count.times do
            post.likes.create!
          end
          
          puts "  Added #{like_count} likes to #{title}"
        else
          puts "  Failed to create post: #{title}, errors: #{post.errors.full_messages.join(', ')}"
        end
      end
    end

    puts "\nTest data generation completed!"
    puts "Summary:"
    puts "- Created #{Post.by_period('1_month').count} posts in the last month"
    puts "- Created #{Post.by_period('3_months').count} posts in the last 3 months"
    puts "- Created #{Post.by_period('1_year').count} posts in the last year"
    puts "- Created #{Post.by_period('3_years').count} posts in the last 3 years"
    puts "- Posts with >10 likes: #{Post.by_likes_count('10').count}"
    puts "- Posts with >50 likes: #{Post.by_likes_count('50').count}"
    puts "- Posts with >100 likes: #{Post.by_likes_count('100').count}"
  end

  # Generate realistic content for test posts
  def generate_content(period, index)
    # Base content with markdown formatting
    base_content = <<~MARKDOWN
      # Sample blog post for #{period} period
      
      This is a test blog post created for testing the filtering functionality.
      
      ## Key points
      
      - This post was created to test the time period filter
      - It falls within the **#{period}** time period
      - It has a specific number of likes for testing like count filtering
      
      ## Code example
      
      ```ruby
      def test_method
        puts "This is sample code for our test post #{index + 1}"
      end
      ```
      
      ## Additional details
      
      Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam euismod, 
      nisi vel consectetur interdum, nisl nisi aliquam nisi, eget consectetur
      nisl nisl eget nisl. Sed euismod, nisi vel consectetur interdum, nisl nisi
      aliquam nisi, eget consectetur nisl nisl eget nisl.
      
      ### Testing features
      
      This post is specifically created to test search functionality by time period and like count.
      Feel free to use this post for testing various filtering conditions in combination.
    MARKDOWN
    
    # Add some random paragraphs based on the index to make posts unique
    extra_paragraphs = []
    (index + 2).times do |i|
      extra_paragraphs << <<~PARAGRAPH
        
        ## Additional section #{i + 1}
        
        This is additional content to make each post unique and searchable.
        You can search for terms like "additional section #{i + 1}" to find this post.
        
        - Item #{i + 1}.1
        - Item #{i + 1}.2
        - Item #{i + 1}.3
        
      PARAGRAPH
    end
    
    base_content + extra_paragraphs.join("\n")
  end
end