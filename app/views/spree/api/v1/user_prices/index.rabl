object false

child(@user_prices => :user_variants) do
  extends 'spree/api/v1/user_prices/price'
end

node(:total_count) { @user_prices.total_count }
node(:current_page) { params[:page] ? params[:page].to_i : 1 }
# node(:pages) { @variants.total_pages }

# child(@variants => :variants) do
#   extends 'spree/api/v1/variants/big'
# end
