class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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

  has_many :addresses

  validate :validate_address_limit, on: :create

  private

  def validate_address_limit
    errors.add(:base, 'Exceeded maximum address limit') if address.count >= 5
  end

end
