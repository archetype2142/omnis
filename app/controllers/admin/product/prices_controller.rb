module Admin
  module Product
    class PricesController < Admin::ApplicationController
      before_action :set_product, only: [:show, :index, :update, :destroy]
      
      def new; end

      def index
        @prices = @product.master.prices
      end

      def show; end

      def edit; end
      
      def update; end

      def set_product
        @product = Spree::Product.friendly.find(params[:product_id]) if params[:product_id]
      end
    end
  end
end
