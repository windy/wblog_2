require 'markdown'
class Post < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :labels
  has_one_attached :cover_image

  has_many :likes
  has_many :votes, dependent: :destroy

  validates :title, :presence=>true, :uniqueness=> true
  validates :content, :presence=>true, :length => { :minimum=> 3 }

  scope :votable, -> { where(enable_voting: true) }
  
  # 按时间段过滤文章
  scope :by_period, ->(period) {
    return all if period.blank?
    
    case period
    when "1_month"
      where('posts.created_at >= ?', 1.month.ago)
    when "3_months"
      where('posts.created_at >= ?', 3.months.ago)
    when "1_year"
      where('posts.created_at >= ?', 1.year.ago)
    when "3_years"
      where('posts.created_at >= ?', 3.years.ago)
    else
      all
    end
  }
  
  # 按点赞数量过滤文章
  scope :by_likes_count, ->(count) {
    return all if count.blank?
    
    case count
    when "10"
      joins(:likes).group('posts.id').having('COUNT(likes.id) > 10')
    when "50"
      joins(:likes).group('posts.id').having('COUNT(likes.id) > 50')
    when "100"
      joins(:likes).group('posts.id').having('COUNT(likes.id) > 100')
    else
      all
    end
  }

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

  def vote_count_for(type)
    self.votes.where(vote_type: type).count
  end

  def vote_percentage_for(type)
    total = total_votes
    return 0 if total == 0
    ((vote_count_for(type).to_f / total) * 100).to_i
  end

  def total_votes
    self.votes.count
  end
end