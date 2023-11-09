class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.integer :genre
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.reference :user_id
      t.reference :region_id
      t.reference :province_id
      t.reference :city_id
      t.reference :barangay_id
      t.integer :role, default: 0
      t.timestamps
    end
  end
end
