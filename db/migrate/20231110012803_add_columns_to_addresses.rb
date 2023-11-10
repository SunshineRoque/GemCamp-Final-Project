class AddColumnsToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :region_id, :bigint
    add_column :addresses, :province_id, :bigint
    add_column :addresses, :city_id, :bigint
    add_column :addresses, :barangay_id, :bigint
  end
end
