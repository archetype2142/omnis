module Admin
  class PropretiesController < Admin::ApplicationController  
    before_action :set_product, only: [:index, :show, :update, :destroy]

    def index; end

    def update; end

    private

    def set_product
      @product ||= Spree::Product.friendly.find(params[:product_id])
    end
  end
end