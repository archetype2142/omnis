module Admin
  class PricesController < Admin::ApplicationController
    before_action :set_product
    before_action :set_price, only: [:edit, :update, :destroy]
    
    def new; end

    def index
      @prices = @product.master.prices
    end

    def show; end

    def edit; end

    def create
      price = Spree::Price.new(new_price_params)

      if price.save
        user_price_book = new_price_params[:user].price_book
        if user_price_book
          user_price_book.prices << price
        else
          Spree::PriceBook.create!(user: new_price_params[:user]).prices << price
        end

        redirect_to admin_product_prices_path(@product), flash: { success: "Created new price!" }
      else
        flash.now[:error] = @price.errors
        render :create
      end
    end
    
    def update
      if @price.update(price_params)
        flash.now[:success] = "Updated!"
        render :edit
      else
        flash.now[:error] = @price.errors
        render :edit
      end
    end

    def destroy
      if @price.destroy
        redirect_to admin_product_prices_path(@product), flash: { error: "Deleted!" }
      else
        flash.now[:error] = @price.errors
        render :index
      end
    end

    protected

    def price_params
      params.require(:price).permit(
        :amount,
        :currency
      )
    end

    def new_price_params
      {
        variant_id: params[:price]['variant'],
        user: Spree::User.find(params[:price]['user']),
        amount: params[:price]['amount'],
        currency: params[:price]['currency']
      }
    end

    def set_price
      if Spree::Price.find(params[:id])
        @price ||= Spree::Price.find_by!(id: params[:id])
      end
    end

    def set_product
      @product = Spree::Product.friendly.find(params[:product_id]) if params[:product_id]
    end
  end
end
