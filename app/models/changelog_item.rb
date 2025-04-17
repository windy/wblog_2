class ChangelogItem < ApplicationRecord
  belongs_to :changelog
  
  validates :title, presence: true
  validates :item_type, presence: true, inclusion: { in: %w[feature improvement bugfix] }
  
  scope :features, -> { where(item_type: 'feature') }
  scope :improvements, -> { where(item_type: 'improvement') }
  scope :bugfixes, -> { where(item_type: 'bugfix') }
end