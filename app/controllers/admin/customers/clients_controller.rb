module Admin
  class Customers::ClientsController < Customers::ApplicationController
    helper_method :all_users
    helper_method :user 

    def create
      puts params
      
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
    
    def index; end
    
    def show; end

    protected 
    
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

    def user
      user ||= Spree::User.find(params[:id])
    end

    def all_users
      all_users = Spree::User
      .order(created_at: :desc)
      .preload(:spree_roles).preload(:addresses)
    end
  end
end