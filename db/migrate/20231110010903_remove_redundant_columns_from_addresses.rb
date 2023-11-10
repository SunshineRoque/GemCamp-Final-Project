class RemoveRedundantColumnsFromAddresses < ActiveRecord::Migration[7.0]
  def change
    remove_column :addresses, :user_id_id, :bigint
    remove_column :addresses, :region_id_id, :bigint
    remove_column :addresses, :province_id_id, :bigint
    remove_column :addresses, :city_id_id, :bigint
    remove_column :addresses, :barangay_id_id, :bigint
  end
end
