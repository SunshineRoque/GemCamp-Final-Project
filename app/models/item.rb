class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :batch_count, presence: true
  enum status: { active: 0, inactive: 1 }
  mount_uploader :image, ImageUploader

  def destroy
    update(deleted_at: Time.current)
  end

  has_many :item_category_ships, dependent: :restrict_with_error
  has_many :categories, through: :item_category_ships
end
