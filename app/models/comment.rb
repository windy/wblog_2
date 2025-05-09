class Comment < ApplicationRecord
  belongs_to :post

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :content, presence: true, length: { minimum: 4 }
  validate :no_forbidden_keywords

  def reply_emails
    Comment.where(post_id: self.post_id).collect(&:email).uniq - [ self.email ] - Subscribe.unsubscribe_list - [ ENV['ADMIN_USER'] ]
  end

  private

  def no_forbidden_keywords
    return unless content.present?

    forbidden_keywords = load_forbidden_keywords
    forbidden_keywords.each do |keyword|
      if content.include?(keyword)
        errors.add(:content, "包含禁用关键词")
        break
      end
    end
  end

  def load_forbidden_keywords
    keywords_file = Rails.root.join('config', 'forbidden_keywords.yml')
    return [] unless File.exist?(keywords_file)

    begin
      YAML.load_file(keywords_file)['keywords'] || []
    rescue
      []
    end
  end
end
