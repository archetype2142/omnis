module Spree
  class PhysicalStore < Spree::Base 
    belongs_to :subsidiary
    belongs_to :company
    has_many :users

    before_create :ensure_company


    def ensure_company
      self.company = Spree::Subsidiary.find(self.subsidiary_id).company
    end
  end
end