module Admin
  class Customers::PricesController < Customers::ApplicationController
    include CustomerHelper

    rescue_from Spree::Core::DestroyWithOrdersError, with: :user_destroy_with_orders_error
    helper_method :user 
    before_action :set_price, only: [:show, :update, :destroy]
    before_action :set_product, only: [:show, :update]

    def index
      user = Spree::User.find(params[:customer_id])
      Spree::PriceBook.create!(user: user) if user.price_book == nil
      
      @q = user
        .price_book
        .prices
        .ransack(params[:q])
      
      @prices = @q
        .result.includes(:variant)
        .page(params[:page])
        .per(params[:per_page])

      respond_to do |format|
        format.html
        format.json { render json: @prices }
      end
    end

    def update; end

    def new; end

    def create; end

    def destroy
      if @price.destroy
        redirect_to admin_customer_prices_path(user), flash: { error: "Deleted!" }
      else
        flash.now[:error] = @price.errors
        render :index
      end
    end

    protected 
    
    def user
      user ||= Spree::User.find(params[:customer_id])
    end

    def set_price
      @price ||= Spree::Price.find(params[:id])
    end

    def set_product
      @product ||= @price.product
    end
  end
end