module Admin
  module Customers
    class ApplicationController < ::ApplicationController
      helper NavigationHelper
      helper_method :user, :all_users

      def user
        if params[:customer_id]
          user ||= Spree::User.find(params[:customer_id])
        elsif params[:id]
          user ||= Spree::User.find(params[:id])
        end
      end

      def all_users
        all_users = Spree::User
        .order(created_at: :desc)
        .preload(:spree_roles).preload(:addresses)
      end
    end
  end
end
