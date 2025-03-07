class Vote < ApplicationRecord
  belongs_to :post

  enum vote_type: { recommend: 0, so_so: 1, swipe_away: 2 }

  validates :post_id, presence: true
  validates :ip_address, presence: true
  # Modified validation to consider both ip_address and session_id
  validates :ip_address, uniqueness: { 
    scope: [:post_id, :session_id],
    message: 'You can only vote once per post'
  }, if: -> { session_id.present? }
  validates :ip_address, uniqueness: { 
    scope: :post_id,
    message: 'You can only vote once per post'
  }, if: -> { session_id.blank? }
  validates :vote_type, presence: true

  # Scopes for counting different types of votes
  scope :recommends, -> { where(vote_type: :recommend) }
  scope :so_sos, -> { where(vote_type: :so_so) }
  scope :swipe_aways, -> { where(vote_type: :swipe_away) }

  # Count methods for each vote type
  def self.recommends_count
    recommends.count
  end

  def self.so_sos_count
    so_sos.count
  end

  def self.swipe_aways_count
    swipe_aways.count
  end
  
  # Find a vote by both ip_address and session_id identifiers
  def self.find_by_identifiers(ip_address, session_id)
    if session_id.present?
      where(ip_address: ip_address, session_id: session_id).first ||
      where(ip_address: ip_address, session_id: nil).first
    else
      find_by(ip_address: ip_address)
    end
  end
end