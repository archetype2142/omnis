module Admin
  class ImagesController < ::ApplicationController  
    helper_method :scope, :sidebar_items
    before_action :set_image, only: [:show, :destroy, :update]
    
    def index
      @product = scope
    end

    def show
      @product = scope
    end

    def destroy
      @image.destroy!
      
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

    def update
      if @image.update(image_update_params)
        flash = { success: "Updated!" }
      else
        flash = @image.errors
      end

      redirect_to admin_product_image_path(scope, @image), flash: flash
    end

    protected 
    
    def scope
      if params[:product_id]
        Spree::Product.friendly.find(params[:product_id])
      end
      # elsif params[:variant_id]
        # Spree::Variant.find(params[:variant_id])
      # end
    end

    private

    def image_update_params
      params.require(:image).permit(
        :viewable_id,
        :alt,
        :attachment_file_name
      )
    end

    def set_image
      @image = Spree::Image.find(params[:id])
    end

    def image_params
      {
        attachment: params[:image],
        attachment_file_name: params[:image].original_filename
      }
    end
  end
end
