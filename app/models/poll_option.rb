class PollOption < ApplicationRecord
  belongs_to :poll
  has_many :votes, dependent: :destroy

  validates :content, presence: true

  after_initialize :set_default_votes_count, if: :new_record?

  private

  def set_default_votes_count
    self.votes_count ||= 0
  end
end