class AddPhysicalStoreToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :spree_users, :physical_store, index: true
  end
end
