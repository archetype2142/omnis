module Admin
  class Customers::OrdersController < Customers::ApplicationController
    helper_method :user 

    def index
      puts params
    end

    def user
      user ||= Spree::User.find(params[:id])
    end
  end
end