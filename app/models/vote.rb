class Vote < ApplicationRecord
  belongs_to :post

  enum vote_type: { excellent: 0, normal: 1, poor: 2 }

  validates :post_id, :vote_type, :session_id, presence: true
  validates :session_id, uniqueness: { scope: :post_id, message: "has already voted on this post" }
end