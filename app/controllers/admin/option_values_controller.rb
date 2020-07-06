module Admin
  class OptionValuesController < Admin::ApplicationController  
    before_action :set_option, only: [:show, :create, :update, :destroy]

    def index
      @option_types = Spree::OptionType.all
    end

    def show
      @option_values = @option_type.option_values
    end

    def destroy
    end

    def update; end

    def create
      begin
        option_params.values.each do |op|
          print op
          # next if op['name'] == "" || op['presentation'] == ""
          if op['id']
            Spree::OptionValue.find(op['id']).update!(
              name: op['name'], 
              presentation: op['presentation']
            )
          else
            @option_type.option_values.create!(
              name: op['name'], 
              presentation: op['presentation']
            )
          end
        end
        flash = { success: "Saved!" }
      rescue ActiveRecord::RecordInvalid => invalid
        flash = { error: invalid.record.errors }
      end

      redirect_to admin_option_type_path(params[:option_type][:id]), flash: flash
    end

    private 
    
    def set_option
      @option_type ||= Spree::OptionType.find(params[:option_type][:id])
    end

    def option_params
      params[:option_type][:option]
    end
  end
end