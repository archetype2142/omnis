module Admin
  class OrdersController < ::ApplicationController
    before_action :authenticate_spree_user!
    
    def index; end

    def show; end

    def destroy; end

    def create; end

    def new; end
  end
end