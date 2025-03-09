class Comment < ApplicationRecord
  belongs_to :post

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :content, presence: true, length: { minimum: 4 }

  after_initialize :set_default_sensitive_word_values

  def reply_emails
    Comment.where(post_id: self.post_id).collect(&:email).uniq - [ self.email ] - Subscribe.unsubscribe_list - [ ENV['ADMIN_USER'] ]
  end

  def display_content
    has_sensitive_words? ? filtered_content : content
  end

  private

  def set_default_sensitive_word_values
    self.filtered_content ||= content
    self.has_sensitive_words ||= false
    self.sensitive_word_count ||= 0
  end
end