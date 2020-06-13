module Admin
  class StocksController < Admin::ApplicationController  
    helper ProductsHelper
    
    before_action :set_product, only: [:show, :update, :destroy]
    helper_method :all_product
  end
end