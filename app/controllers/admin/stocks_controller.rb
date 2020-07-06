module Admin
  class StocksController < Admin::ApplicationController  
    helper ProductsHelper
    
    before_action :set_product, only: [:show, :update, :destroy]
    helper_method :all_product

    def index
      @product = scope
      @stock_locations = Spree::StockLocation.all
      @variants = scope.variants_including_master
    end

    def destroy
      stock_item = Spree::StockItem.find(params[:id])

      if stock_item.destroy
        flash = { success:  "Deleted Successfully" }
      else
        flash = { error: stock_item.errors }
      end

      redirect_to admin_product_stocks_path(@product), flash: flash
    end

    def update
      stock_item = Spree::StockItem.find(params[:id])
      
      if stock_item.update(stock_movement_params)
        flash = { success: "Variant Saved!" }
      else
        flash = { error: stock_item.errors }
      end

      redirect_to admin_product_stocks_path(@product), flash: flash
    end

    def create
      variant = Spree::Variant.find(params[:stock]['variant_id'])
      stock_location = Spree::StockLocation.find(params[:stock]['stock_location_id'])
      stock_item = stock_location.stock_items.find_by(variant_id: variant.id)
      
      count_on_hand = params['stock']['quantity'].to_i

      updated = stock_item ? stock_item.adjust_count_on_hand(count_on_hand)
          : Spree::StockItem.create!(stock_params)

      if updated
        flash = { success: "Stock Added!" }
      else
        flash = { error: "Error adding stock!"}
      end

      redirect_to admin_product_stocks_path(scope), flash: flash
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

    def set_product
      @product ||= Spree::Product.friendly.find(params[:product_id])
    end

    def stock_item
      @stock_item ||= StockItem.find(params[:id])
    end

    def stock_item_params
      params.require(:stock).permit(:variant_id, :stock_location_id, :quantity)
    end

    def stock_movement_params
      params.require(:stock_item).permit(:backorderable)
    end

    def stock_params
      {
        variant_id: params['stock']['variant_id'],
        stock_location_id: params['stock']['stock_location_id'],
        count_on_hand: params['stock']['quantity'],
      }
    end
  end
end
