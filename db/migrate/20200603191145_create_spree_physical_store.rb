class CreateSpreePhysicalStore < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_physical_stores do |t|
      t.string :name
      t.references :users, index: true 
      t.references :subsidiary, null: false
      t.references :company, index: true
    end
  end
end
