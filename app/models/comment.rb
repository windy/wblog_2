class Comment < ApplicationRecord
  belongs_to :post

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :content, presence: true, length: { minimum: 4 }

  before_save :filter_sensitive_words

  def reply_emails
    Comment.where(post_id: self.post_id).collect(&:email).uniq - [ self.email ] - Subscribe.unsubscribe_list - [ ENV['ADMIN_USER'] ]
  end

  private

  # 过滤评论内容中的敏感词
  def filter_sensitive_words
    return unless content.present? && defined?(SENSITIVE_WORDS)
    
    filtered_content = content.dup
    
    # 遍历敏感词列表，使用正则表达式替换所有匹配项
    SENSITIVE_WORDS.each do |word|
      next if word.blank?
      
      # 创建不区分大小写的正则表达式
      regex = Regexp.new(Regexp.escape(word), Regexp::IGNORECASE)
      
      # 将敏感词替换为**
      filtered_content.gsub!(regex, '**')
    end
    
    # 更新内容
    self.content = filtered_content
  end
end