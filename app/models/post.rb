require 'markdown'
class Post < ActiveRecord::Base
  has_many :comments
  has_and_belongs_to_many :labels
  has_many :likes
  has_one_attached :cover_image

  validates :title, :presence=>true, :uniqueness=> true
  validates :content, :presence=>true, :length => { :minimum=> 3 }
  
  validate :cover_image_format_and_size
  
  def cover_image_format_and_size
    return unless cover_image.attached?
    
    # 验证图片大小不超过5MB
    if cover_image.byte_size > 5.megabytes
      errors.add(:cover_image, 'size should be less than 5MB')
      cover_image.purge
    end
    
    # 验证图片类型
    acceptable_types = ['image/jpeg', 'image/png', 'image/gif']
    unless acceptable_types.include?(cover_image.content_type)
      errors.add(:cover_image, 'must be a JPEG, PNG or GIF')
      cover_image.purge
    end
  end

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
end