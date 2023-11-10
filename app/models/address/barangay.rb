class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city

  def self.table_name_prefix
    "address_"
  end

end
