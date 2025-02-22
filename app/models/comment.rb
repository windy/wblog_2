class Comment < ApplicationRecord
  belongs_to :post

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :content, presence: true, length: { minimum: 4 }
  validate :validate_content_sensitivity

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

  def validate_content_sensitivity
    sensitive_words = YAML.load_file(Rails.root.join('config', 'ss.yml'))['sensitive_words']
    sensitive_words.each do |word|
      if content&.include?(word)
        errors.add(:content, :sensitive_word, word: word)
        break
      end
    end
  end
end