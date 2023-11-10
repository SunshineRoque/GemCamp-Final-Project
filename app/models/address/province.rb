class Address::Province < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :region
  has_many :cities, class_name: 'Address::City', foreign_key: 'province_id'

  def self.table_name_prefix
    "address_"
  end
end
