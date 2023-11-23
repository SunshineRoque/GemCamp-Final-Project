class RemoveIndexAddressInWinners < ActiveRecord::Migration[7.0]
  def change
    change_column :winners, :address_id, :bigint, null: true
  end
end
