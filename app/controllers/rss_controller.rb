require 'rss'

class RssController < ApplicationController
  def index
    @posts = Post.order(created_at: :desc).limit(10)

    respond_to do |format|
      format.xml do
        render xml: generate_rss(@posts)
        response.headers['Content-Type'] = 'application/xml; charset=utf-8'
      end
    end
  end

  private

  def generate_rss(posts)
    RSS::Maker.make("2.0") do |maker|
      maker.channel.title = "My Blog RSS Feed"
      maker.channel.link = root_url
      maker.channel.description = "Latest blog posts from my website"
      maker.channel.language = "en"
      maker.channel.updated = Time.now.to_time.rfc822
      maker.channel.author = "Blog Author"

      posts.each do |post|
        maker.items.new_item do |item|
          item.link = blog_url(post)
          item.title = post.title
          item.description = post.sub_content
          item.pubDate = post.created_at.to_time.rfc822
        end
      end
    end.to_s
  end
end