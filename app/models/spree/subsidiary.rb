module Spree
  class Subsidiary < Spree::Base
    belongs_to :company
    has_many :physical_stores
    has_many :users, through: :company, source: :users

    def owners
      self.users.select { |u| u.subsidiary_owner? }
    end
  end
end