class AddDefaultToSpreeBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_price_books, :default, :boolean, default: false, null: false
    add_column :spree_price_books, :active_from, :datetime 
    add_column :spree_price_books, :active_to, :datetime
  end
end
