class Offer < ApplicationRecord
  validates :name, presence: true
  validates :amount, presence: true
  validates :coin, presence: true
  enum status: { active: 0, inactive: 1 }
  mount_uploader :image, ImageUploader
  has_many :orders
end
