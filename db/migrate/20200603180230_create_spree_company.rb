class CreateSpreeCompany < ActiveRecord::Migration[6.0]
  def change
    create_table :spree_companies do |t|
      t.string :nip
      t.string :name
      t.references :spree_users, index: true 
      t.references :user, index: true 
    end
  end
end
