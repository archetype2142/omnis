module Admin
  class OptionTypesController < Admin::ApplicationController  
    before_action :set_option, only: [:show, :update, :destroy]

    def index
      @option_types = Spree::OptionType.all
    end
    
    def new; end

    def show
      @option_values = @option_type.option_values
    end

    def create
      option = Spree::OptionType.new(name: params[:name], presentation: params[:presentation])
      if option.save
        flash = { success: "Saved!" }
        redr = admin_option_type_path(option)
      else
        flash = { error: option.errors }
        redr = new_admin_option_type_path
      end

      redirect_to redr, flash: flash
    end

    def update
      if @option_type.update(option_params)
        flash = { success: "Updated!" }
      else
        flash = { error: @option_type.errors }
      end

      redirect_to admin_option_type_path(params[:id]), flash: flash
    end

    def destroy
      option = Spree::OptionType.find(params[:id])

      if option.destroy
        flash = { success: "Option destroy!" }
      else
        flash = { error: option.errors }
      end

      redirect_to admin_option_types_path, flash: flash
    end

    def update_option_position
      positions = params[:order].keys

      positions.each_with_index do |pos, i|
        Spree::OptionType.find(pos).update!(position: i+1)
      end
    end

    private 
    
    def set_option
      @option_type ||= Spree::OptionType.find(params[:id])
    end

    def option_params
      params.require(:option_type).permit(:name, :presentation)
    end
  end
end
