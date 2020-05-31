module Admin
  class ProductsController < Admin::ApplicationController  
    helper ProductsHelper
    
    before_action :set_product, only: [:show, :update, :destroy]
    helper_method :all_products
    
    def new; end

    def index
      @products = Spree::Product.all

      respond_to do |format|
        format.html
        format.json { render json: @products }
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { render json: @product }
      end
    end

    def create
      @product = Spree:Product.new(product_params)

      if params['product_image']
        im = Image.create!(image_params)
        @product.images << im
      end

      if @product.save
        redr = admin_product_path(@product)
        notice = { notice: "created new product" }
      else
        redr = new_admin_product_path
        notice = { alert: @product.errors }
      end

      redirect_to redr, flash: notice
        
    end

    def update
      if @product.update(product_params)
        respond_to do |format|
          format.html { redirect_to admin_product_path(@product), flash: { 'is-primary': "Updated Successfully!"} }
          format.json { render json: @product }
        end
      else
        respond_to do |format|
          format.html { redirect_to admin_product_path(@product), flash: { 'is-danger': @product.errors } }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @product.destroy
    end

    private

    def set_product
      @product = Spree::Product.find_by!(slug: params[:id])
    end
    
    def image_params
      {
        attachment: {
          io: params['product_image'],
          filename: params['product_image']
        }
      }
    end
    
    def product_params
      {
        name: params[:product]['name'],
        sku: params[:product]['sku'],
        default_price: Monetize.parse("#{params[:product]['price']} #{params[:product]['currency']}"),
        cost_price: params[:product]['cost_price'],
        tax_category_id: params[:product]['tax_category_id'],
        shipping_category_id: params[:product]['shipping_category_id'],
        slug: params[:product][:slug] || params[:product]['name'].split(" ").join("-"),
        description: params[:product][:description],
        currency: params[:product][:currency]
      }
    end

    def all_products
      all_products = Spree::Product
      .order(created_at: :desc)
    end
  end
end