class Vote < ApplicationRecord
  belongs_to :post
  
  validates :session_id, presence: true
  validates :option, presence: true, inclusion: { in: ['very_good', 'average', 'pass_by'] }
  
  scope :very_good_votes, -> { where(option: 'very_good') }
  scope :average_votes, -> { where(option: 'average') }
  scope :pass_by_votes, -> { where(option: 'pass_by') }
  
  def self.count_by_option
    {
      very_good: very_good_votes.count,
      average: average_votes.count,
      pass_by: pass_by_votes.count
    }
  end
end