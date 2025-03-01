class Photo < ApplicationRecord
  mount_uploader :image, PhotoUploader
  belongs_to :post, optional: true
  has_one :comment
end