class SpamWord < ApplicationRecord
  validates :word, presence: true
  
  # Default value for active field
  attribute :active, :boolean, default: true
  
  # Scope to get only active spam words
  scope :active, -> { where(active: true) }
  
  # Default replacement if none specified
  before_save :set_default_replacement
  
  # Class method to filter spam words from content
  def self.filter_content(text)
    return text if text.blank?
    
    # Get all active spam words
    active.each do |spam_word|
      # Replace spam word with its replacement using case-insensitive regex
      text = text.gsub(/#{Regexp.escape(spam_word.word)}/i, spam_word.replacement)
    end
    
    text
  end
  
  private
  
  def set_default_replacement
    self.replacement = '**' if replacement.blank?
  end
end