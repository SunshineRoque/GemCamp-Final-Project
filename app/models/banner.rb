class Banner < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validates :status, presence: true
  enum status: { active: 0, inactive: 1 }
  mount_uploader :preview, ImageUploader
end
