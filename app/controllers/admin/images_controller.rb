module Admin
  class ImagesController < ::ApplicationController  
    helper_method :scope, :sidebar_items

    def index
      @product = scope
    end

    def destroy
      Spree::Image.find(params[:id]).destroy!
      
      redirect_to admin_product_images_path(scope), flash: { 'is-primary': 'Deleted Successfully!'}
    end

    def create
      @image = scope.images.new(image_params)

      if @image.save
        redirect_to admin_product_images_path(scope), flash: { 'is-primary': 'Saved Successfully!'}
      else
        redirect_to admin_product_images_path(scope), flash: { 'is-danger': 'Could not save Image'}
      end
    end

    protected 
    
    def scope
      if params[:product_id]
        Spree::Product.friendly.find(params[:product_id])
      elsif params[:variant_id]
        Spree::Variant.find(params[:variant_id])
      end
    end

    private

    def image_params
      {
        attachment: params[:image],
        attachment_file_name: params[:image].original_filename
      }
    end
  end
end