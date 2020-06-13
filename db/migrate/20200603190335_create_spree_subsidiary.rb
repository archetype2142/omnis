class CreateSpreeSubsidiary < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_subsidiaries do |t|
      t.string :name
      t.references :spree_users, index: true 
      t.references :company, null: false
    end
  end
end
