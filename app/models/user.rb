class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :phone_number, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  enum role: { client: 0, admin: 1 }

  mount_uploader :image, ImageUploader
  belongs_to :parent, class_name: 'User', foreign_key: 'parent_id', optional: true
  has_many :children, class_name: 'User', foreign_key: 'parent_id'
  has_many :addresses

  validate :validate_address_limit, on: :create

  private

  def validate_address_limit
    errors.add(:base, 'Exceeded maximum address limit') if addresses.count >= 5
  end

end
