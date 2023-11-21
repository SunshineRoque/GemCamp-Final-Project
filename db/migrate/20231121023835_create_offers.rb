class CreateOffers < ActiveRecord::Migration[7.0]
  def change
    create_table :offers do |t|
      t.string :image
      t.string :name
      t.integer :status
      t.integer  :coin
      t.decimal :amount
      t.timestamps
    end
  end
end
