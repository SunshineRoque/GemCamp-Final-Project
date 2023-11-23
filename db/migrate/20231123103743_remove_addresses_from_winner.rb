class RemoveAddressesFromWinner < ActiveRecord::Migration[7.0]
  def change
    remove_column :winners, name: "index_winners_on_admin_id"
  end
end
