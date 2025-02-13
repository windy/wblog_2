# frozen_string_literal: true

class SensitiveWordService
  def initialize
    @sensitive_words = Rails.configuration.sensitive_words['words'] || []
  end

  def filter(text)
    return text if text.blank?

    filtered_text = text.dup
    @sensitive_words.each do |word|
      filtered_text.gsub!(word, '***') if filtered_text.include?(word)
    end
    filtered_text
  end

  private

  def load_sensitive_words
    yaml_path = Rails.root.join('config', 'words.yml')
    return [] unless File.exist?(yaml_path)

    YAML.load_file(yaml_path)['words'] || []
  rescue StandardError => e
    Rails.logger.error "Failed to load sensitive words: #{e.message}"
    []
  end
end