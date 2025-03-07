require 'markdown'
class Post < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :labels

  has_many :likes
  has_many :votes

  validates :title, :presence=>true, :uniqueness=> true
  validates :content, :presence=>true, :length => { :minimum=> 3 }

  def content_html
    self.class.render_html(self.content)
  end

  def self.render_html(content)
    rd = CodeHTML.new
    md = Redcarpet::Markdown.new(rd, autolink: true, fenced_code_blocks: true)
    md.render(content)
  end

  def visited
    self.visited_count += 1
    self.save
    self.visited_count
  end

  # truncate content for home page display
  def sub_content
    HTML_Truncator.truncate(content_html, 300, length_in_chars: true)
  end

  # truncate content for meta description display
  def meta_content
    html = HTML_Truncator.truncate(content_html, 100, :length_in_chars => true, ellipsis: '')
    # Easily get text for Nokogiri
    html = '<div>' + html + '</div>'
    Nokogiri.parse(html).text()
  end

  def labels_content( need_blank=false )
    content = self.labels.collect { |label| label.name }.join(", ")
    content = I18n.t('none') if content.blank? and !need_blank
    content
  end

  def liked_count
    self.likes.size
  end

  def liked_by?(like_id)
    !! self.likes.where(id: like_id).first
  end
  
  # Vote counting methods
  def recommends_count
    votes.recommends.count
  end
  
  def so_sos_count
    votes.so_sos.count
  end
  
  def swipe_aways_count
    votes.swipe_aways.count
  end
  
  # Check if user with given IP has already voted
  def voted_by?(ip_address)
    votes.where(ip_address: ip_address).exists?
  end
  
  # Get the vote type for a specific IP address
  def vote_type_for(ip_address)
    vote = votes.find_by(ip_address: ip_address)
    vote&.vote_type
  end
end