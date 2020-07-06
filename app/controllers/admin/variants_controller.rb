module Admin
  class VariantsController < Admin::ApplicationController  
    before_action :set_product, only: [:index, :show, :update, :destroy, :new, :create]
    before_action :set_variant, only: [:show, :update, :destroy]
    
    def index
      @variants = @product.variants
    end

    def destroy
      if @variant.destroy
        flash = { success: "Deleted!" }
      else
        flash = { error: @variant.error }
      end

      redirect_to admin_product_variants_path(@product)
    end

    def update
      begin 
        selected = params[:variant][:option_values].each do |op, id|
          if id["option_values"] == ""
            @variant
            .option_values
            .delete(
              Spree::OptionValue.where(
                option_type_id: op
              )
            ).first if @variant.option_values.find_by(option_type_id: op)
          else
            @variant.option_values << Spree::OptionValue.find(id["option_values"]) if @variant.option_values.find_by(id: id["option_values"]).nil?
          end
        end

        if @variant.update(update_variant_params)
          flash = { success: "Updated!" }
        else
          flash = { error: @variant.errors }
        end
      rescue ActiveRecord::RecordInvalid => e
        flash = { error: e.record.errors }
      end

      redirect_to admin_product_variant_path(@product, @variant), flash: flash
    end

    def create
      variant = @product.variants.new(variant_params)

      selected = params[:variant][:option_values].each do |id, op|
        next if op["option_value_ids"] == ""
        variant.option_values << Spree::OptionValue.find(op["option_value_ids"])
      end

      if variant.save
        flash = { success: "Created!" }
        redr = admin_product_variants_path(@product)
      else
        flash = { error: variant.errors }
        redr = new_admin_product_variant_path(@product)
      end

      redirect_to redr, flash: flash
    end

    def new; end

    def show; end
    private

    def set_product
      @product ||= Spree::Product.friendly.find(params[:product_id])
    end
    
    def set_variant
      @variant ||= Spree::Variant.find(params[:id])
    end

    def update_variant_params
      params.require(:variant).permit(
        :cost_price,
        :tax_category_id,
        :weight,
        :height,
        :width,
        :depth,
        :price,
        :sku,
        :name
      )
    end

    def variant_params
      params.require(:variant).permit(
        :track_inventory,
        :weight,
        :height,
        :depth,
        :width,
        :tax_category_id,
        :price,
        :cost_price,
        option_values: [],
        q: []
      )
    end
  end
end
