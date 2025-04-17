class Changelog < ApplicationRecord
  validates :version, presence: true
  validates :title, presence: true
  validates :status, presence: true, inclusion: { in: %w[rolling released] }
  
  has_many :changelog_items, dependent: :destroy
  
  scope :released, -> { where(status: 'released').order(released_at: :desc) }
  scope :rolling, -> { where(status: 'rolling') }
  
  def rolling?
    status == 'rolling'
  end
  
  def released?
    status == 'released'
  end
end