module Spree
  class CompanyEmployee < Spree::Base
    belongs_to :user, class_name: "::#{Spree.user_class}"
    belongs_to :company, class_name: "Spree::Company"
  end
end