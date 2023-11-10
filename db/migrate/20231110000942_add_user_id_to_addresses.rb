class AddUserIdToAddresses < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses, :user
  end
end
