class Address < ApplicationRecord
  validate :validate_address_limit, on: :create
  validates :user, presence: true
  validates :street_address, presence: true
  validates :region, presence: true
  validates :province, presence: true
  validates :city, presence: true
  validates :barangay, presence: true

  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', foreign_key: 'region_id'
  belongs_to :province, class_name: 'Address::Province', foreign_key: 'province_id'
  belongs_to :city, class_name: 'Address::City', foreign_key: 'city_id'
  belongs_to :barangay, class_name: 'Address::Barangay', foreign_key: 'barangay_id'
  has_many :winners

  enum genre: { home: 0, office: 1 }

  private

  def validate_address_limit
    if user&.addresses&.count.to_i >= 5
      errors.add(:base, 'The address limit (5) has already been exceeded.')
    end
  end
end