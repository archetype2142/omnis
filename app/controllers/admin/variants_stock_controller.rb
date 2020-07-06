module Admin
  class VariantsStockController < Admin::ApplicationController  
    before_action :set_product, only: :update

    def update
      variant = @product
        .variants_including_master
        .find(params[:id])
      
      if variant.update(variant_params)
        flash = { success: "Variant Saved!" }
      else
        flash = { error: variant.errors }
      end

      redirect_to admin_product_stocks_path(@product), flash: flash
    end  

    private

    def set_product
      @product ||= Spree::Product.friendly.find(params[:product_id])
    end

    def variant_params
      params.require(:variant).permit(:track_inventory)
    end
  end
end