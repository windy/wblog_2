class Changelog < ApplicationRecord
  validates :date, presence: true
  validates :title, presence: true
  validates :content, presence: true
end
