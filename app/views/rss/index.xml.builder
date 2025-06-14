xml.instruct! :xml, version: "1.0"
xml.rss version: "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title ENV['SITE_NAME']
    xml.description ENV['SITE_DESCRIPTION'] || "Blog RSS Feed"
    xml.link root_url
    xml.language "zh-CN"
    xml.tag!("atom:link", href: rss_index_url(format: :xml), rel: "self", type: "application/rss+xml")
    xml.pubDate Time.now.to_time.rfc822
    xml.lastBuildDate Time.now.to_time.rfc822

    @posts.each do |post|
      xml.item do
        xml.title post.title
        xml.description post.sub_content
        xml.pubDate post.created_at.to_time.rfc822
        xml.link blog_url(post)
        xml.guid blog_url(post)
      end
    end
  end
end