class RemoveAmountFromOffers < ActiveRecord::Migration[7.0]
  def change
    remove_column :offers, :amount
  end
end
