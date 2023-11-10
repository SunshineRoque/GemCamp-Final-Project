class Address::Region < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true


  has_many :provinces, class_name: 'Address::Province', foreign_key: 'region_id'

  def self.table_name_prefix
    "address_"
  end
end
