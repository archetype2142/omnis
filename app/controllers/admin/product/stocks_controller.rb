module Admin
  module Product
    class StocksController < ::ApplicationController  
      helper_method :scope, :sidebar_items

      def index
        @product = scope
        @stock_locations = Spree::StockLocation.all
      end

      def destroy        
      end

      def create
      end

      protected 
      
      def scope
        if params[:product_id]
          Spree::Product.friendly.find(params[:product_id])
        elsif params[:variant_id]
          Spree::Variant.find(params[:variant_id])
        end
      end

      private

      def stock_params
      end
    end
  end
end