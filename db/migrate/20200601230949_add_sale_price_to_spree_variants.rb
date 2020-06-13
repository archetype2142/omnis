class AddSalePriceToSpreeVariants < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_variants, :sale_price, :decimal, precision: 8, scale: 2
  end
end
