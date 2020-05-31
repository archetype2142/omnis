class AddClientTypeToSpreeUser < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_users, :client_type, :integer, default: 0
  end
end
