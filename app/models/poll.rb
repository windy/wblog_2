class Poll < ApplicationRecord
  belongs_to :post
  has_many :poll_options, dependent: :destroy
  
  accepts_nested_attributes_for :poll_options, allow_destroy: true, reject_if: :all_blank
  
  validates :title, presence: true
  validate :validate_poll_options_count
  
  private
  
  def validate_poll_options_count
    # Check if we have loaded poll_options
    if poll_options.loaded?
      valid_options_count = poll_options.reject(&:marked_for_destruction?).size
    # Check if we have poll_options_attributes from the form submission
    elsif respond_to?(:poll_options_attributes_before_type_cast) && 
          poll_options_attributes_before_type_cast.present?
      begin
        options_attrs = poll_options_attributes_before_type_cast
        # Handle both hash and array formats
        if options_attrs.is_a?(Hash)
          valid_options_count = options_attrs.values.reject { |attrs| 
            attrs.is_a?(Hash) && attrs['_destroy'] == '1' 
          }.size
        else
          valid_options_count = 0
        end
      rescue => e
        # If there's any error in accessing attributes, skip validation
        return
      end
    else
      # Skip validation if we can't determine the count
      return
    end
    
    if valid_options_count < 3
      errors.add(:base, "Please provide at least 3 poll options")
    elsif valid_options_count > 5
      errors.add(:base, "Maximum 5 poll options are allowed")
    end
  end
end