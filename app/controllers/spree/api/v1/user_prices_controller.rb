module Spree
  module Api
    module V1
      class UserPricesController < Spree::Api::BaseController
        helper_method :variant_attributes
        
        def index
          # @products = Spree::Product.all
          
          expires_in 15.minutes, public: true
          headers['Surrogate-Control'] = "max-age=#{15.minutes}"
          # @user_products = user
          #             .price_books
          #             .eager_load(:variants)
          #             .map{ |p| p.variants }
          @user_prices = user
                        .price_book
                        .variants
                        .includes(*variant_includes)
                        .ransack(params[:q])
                        .result.page(params[:page])
                        .per(params[:per_page])
          
          puts @user_prices.inspect
          
          respond_with(@user_prices, user)
        end

        private

        def user
          if params[:user_id].present?
            @user ||= Spree.user_class.accessible_by(current_ability, :show).find(params[:user_id])
          end
        end

        def scope
          
        end

        def variant_includes
          [ :prices ]
        end

        def variant_attributes 
          [
            :id, :name, :sku, :price, :weight, :height, :width, :depth, :is_master,
            :slug, :description, :track_inventory
          ]
        end
      end
    end
  end
end

# ...map { |p| p.variants.eager_load(:prices).map{ |v| v.prices.map{ |p| p.display_price.to_s} } }.flatten
