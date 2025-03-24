class Like < ApplicationRecord
  belongs_to :post
  
  # Define valid kinds
  KINDS = %w[like unlike].freeze
  
  # Validations
  validates :kind, presence: true, inclusion: { in: KINDS }
  
  # Set default value for kind
  attribute :kind, :string, default: 'like'
  
  # Scopes for querying
  scope :likes, -> { where(kind: 'like') }
  scope :unlikes, -> { where(kind: 'unlike') }
end