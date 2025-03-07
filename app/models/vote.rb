class Vote < ApplicationRecord
  belongs_to :poll_option, counter_cache: true
  belongs_to :poll, optional: true
  
  validates :session_id, presence: true
  validates :session_id, uniqueness: { scope: :poll_option_id, message: "You have already voted for this option" }
  validates :session_id, uniqueness: { scope: :poll_id, message: "You have already voted in this poll" }
  
  before_validation :set_poll
  
  private
  
  def set_poll
    self.poll = poll_option.poll if poll_option
  end
end