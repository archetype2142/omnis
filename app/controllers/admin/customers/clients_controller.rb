module Admin
  class Customers::ClientsController < Customers::ApplicationController
    helper_method :all_users
    helper_method :user 

    def create
      u = Spree::User.create!(
        email: params[:user]['address'],
        password: 'default'
      )

      Address.create!(
        address_params.merge({user: u})
      )

      u.add_role role_return(params[:client_type]['type_id'].to_i)

      redirect_to customers_clients_path
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
        country: Country.find_by(name: params['client']['country_id']),
        city: params['client']['city'],
        state: State.find_by(name: params['client']['state_id'])
      }
    end

    def role_return num
      if num == 1
        :company
      elsif num == 2
        :individual
      else
        :unknown
      end
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