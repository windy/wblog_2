class Comment < ApplicationRecord
  belongs_to :post

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :content, presence: true, length: { minimum: 4 }
  validate :sensitive_words_check

  def reply_emails
    Comment.where(post_id: self.post_id).collect(&:email).uniq - [ self.email ] - Subscribe.unsubscribe_list - [ ENV['ADMIN_USER'] ]
  end

  after_commit on: :create do
    if ENV['MAIL_SERVER'].present? && ENV['ADMIN_USER'].present? && ENV['ADMIN_USER'] =~ /@/ && ENV['ADMIN_USER'] != self.email
      Rails.logger.info 'comment created, comment worker start'
      NewCommentWorker.perform_async(self.id.to_s, ENV['ADMIN_USER'])
    end

    if ENV['MAIL_SERVER'].present?
      Rails.logger.info 'comment created, reply worker start'
      NewReplyPostWorker.perform_async(self.id.to_s)
    end
  end

  private

  def sensitive_words_check
    return unless content.present?
    
    found_words = contains_sensitive_words?
    if found_words.any?
      errors.add(:content, :sensitive_words, words: found_words.join(', '))
    end
  end

  def contains_sensitive_words?
    sensitive_words = Rails.application.config.sensitive_words
    found_words = []
    
    sensitive_words.each do |word|
      found_words << word if content.downcase.include?(word.downcase)
    end
    
    found_words
  end
end