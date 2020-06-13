module Admin
  class Customers::AddressesController < Customers::ApplicationController
    rescue_from Spree::Core::DestroyWithOrdersError, with: :user_destroy_with_orders_error
    helper_method :user 

    def index
    end

    def update   
      notice = {}

      ActiveRecord::Base.transaction do
        if user.update(user_params)
          notice = { success: "updated!" } 
        else
          notice = { alert: user.errors }
        end
      end

      redirect_to admin_customers_address_path(user), flash: notice
    end

    private 
    def user
      user ||= Spree::User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :use_billing,
        ship_address_attributes: {},
        bill_address_attributes: {},
        spree_role_ids: []
      )
    end

    def user_destroy_with_orders_error
      invoke_callbacks(:destroy, :fails)
      render status: :forbidden, plain: Spree.t(:error_user_destroy_with_orders)
    end
  end
end