class AddAmountToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :amount, :decimal, default: 0
  end
end
