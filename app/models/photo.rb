class Photo < ApplicationRecord
  mount_uploader :image, PhotoUploader
  has_one :comment, dependent: :nullify
end