class AddAmountToOffers < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :amount, :decimal
  end
end
