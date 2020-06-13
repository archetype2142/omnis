module Admin
  class Customers::ClientsController < Customers::ApplicationController
    def index
      @q = Spree::User.ransack(params[:q])
      
      @users = @q
        .result
        .page(params[:page])
        .per(params[:per_page])


      respond_to do |format|
        format.html
        format.json { render json: @users }
      end
    end
    
    def show; end

    def update
      notice = {}
       ActiveRecord::Base.transaction do
        if user.update(user_params)
          notice = { success: "updated!" } 
        else
          notice = { alert: user.errors }
        end
      end

      redirect_to admin_customers_client_path(user), flash: notice
    end

    def create      
      usr = Spree::User.new(
        email: params[:user]['address'],
        password: 'default'
      )
      
      ActiveRecord::Base.transaction do
        if usr.save
          redr = admin_customers_client_path(usr)
          notice = { notice: "created new product" }

          Spree::Address.create!(
            address_params.merge({user: usr})
          ) 
        else
          redr = admin_customers_clients_path
          notice = { alert: usr.errors }
        end
      end

      redirect_to redr, flash: notice 
    end
    
    def destroy
      Spree::User.find(params[:id]).destroy!

      redirect_to admin_customers_clients_path
    end

    private
    
    def user_params
      {
        client_type: params['user']['client_type'].to_i,
        email: params['user']['email']
      }
    end

    def address_params
      {
        firstname: params['client']['firstname'],
        lastname: params['client']['lastname'],
        address1: params['client']['address1'],
        address2: params['client']['address2'],
        company: params['client']['company'],
        country: Spree::Country.find_by(name: params['client']['country_id']),
        city: params['client']['city'],
        state: Spree::State.find_by(name: params['client']['state_id']),
        zipcode: params['client']['zipcode']
      }
    end
  end
end