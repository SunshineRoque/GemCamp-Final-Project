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
end
