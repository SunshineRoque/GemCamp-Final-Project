class Address::City < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :province
  has_many :barangays, class_name: 'Address::Barangay', foreign_key: 'city_id'

  def self.table_name_prefix
    "address_"
  end
end
