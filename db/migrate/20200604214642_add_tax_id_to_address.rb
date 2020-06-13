class AddTaxIdToAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :spree_addresses, :tax_id, :string
  end
end
