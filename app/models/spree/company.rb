module Spree
  class Company < Spree::Base
    has_many :spree_company_users, class_name: "Spree::CompanyUser"
    has_many :users, through: :spree_company_users, source: :user 

    has_many :subsidiaries
    has_many :physical_stores, through: :subsidiaries

    has_one :price_book
    validates :name, presence: true
    validates :nip, { presence: true, uniqueness: true }

    def employees
      self.physical_stores.map{ |s| s.users.all }
    end
  end
end