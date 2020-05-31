class AddManagerToSpreeUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_users, :manager_id, :integer
  end
end
