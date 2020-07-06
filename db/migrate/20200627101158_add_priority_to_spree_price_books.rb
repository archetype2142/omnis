class AddPriorityToSpreePriceBooks < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_price_books, :priority, :integer
  end
end
