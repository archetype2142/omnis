module Spree
  module HomeControllerDecorator
    def sale
      @products = ::Spree::Product.joins(:variants_including_master).where('spree_variants.sale_price is not null').distinct
    end
  end
end

Spree::HomeController.prepend Spree::HomeControllerDecorator