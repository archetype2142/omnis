class CreateSpreePriceBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_price_books do |t|
      t.string :currency
      t.boolean :discount, default: false, null: false
      t.string :name
      t.references :user, index: true
    end
  end
  
  add_column :spree_prices, :price_book_id, :integer
  add_column :spree_line_items, :list_price, :decimal, precision: 10, scale: 2, default: 0.0
end
