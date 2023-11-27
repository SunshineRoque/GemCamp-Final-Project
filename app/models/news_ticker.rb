class NewsTicker < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  validates :content, presence: true
  validates :status, presence: true
  enum status: { active: 0, inactive: 1 }
  belongs_to :admin, class_name: 'User'
end
