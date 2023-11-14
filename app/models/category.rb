class Category < ApplicationRecord
  validates :name, presence: true
  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :items, through: :item_category_ships
end
