xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title ENV['SITE_NAME']
    xml.description ENV['INTRODUCE']
    xml.link root_url
    xml.language I18n.locale.to_s
    xml.lastBuildDate Time.now.rfc822

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.sub_content
        xml.pubDate post.created_at.rfc822
        xml.link blog_url(post)
        xml.guid blog_url(post)
        
        # Add post labels as categories
        post.labels.each do |label|
          xml.category label.name
        end
      end
    end
  end
end