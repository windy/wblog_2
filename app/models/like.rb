class Like < ApplicationRecord
  belongs_to :post
  validates :score, inclusion: { in: 0..10 }
end