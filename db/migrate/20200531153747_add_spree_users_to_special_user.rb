class AddSpreeUsersToSpecialUser < ActiveRecord::Migration[6.0]
  def change
    add_reference :spree_users, :special_user, index: true
  end
end
