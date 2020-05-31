Rails.application.routes.draw do
  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to
  # Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the
  # :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being
  # the default of "spree".
  mount Spree::Core::Engine, at: "/"
  
  Spree::Core::Engine.add_routes do
    namespace :api, defaults: { format: 'json' } do 
      namespace :v1 do 
        resources :clients, only: :index
        resources :user_prices, only: [:index]
      end
    end        
  end

  get '/admin_api_keys', to: 'spree/api/v1/admin_api_keys#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'frontend/homepage#index'


  namespace :admin do
    root to: "orders#index"
    resources :products, only: [:index, :show, :new, :create, :update] do
      resources :images, only: [:index, :create, :destroy]
    end
    
    resources :orders, only: [:index, :new, :show, :destroy]

    namespace :customers do
      resources :clients, only: [:index, :create, :show]
      resources :companies, only: [:index, :create]
    end
  end

  spree_path = Rails.application.routes.url_helpers.try(:spree_path, trailing_slash: true) || '/'
  get Spree.admin_path, to: redirect((spree_path + Spree.admin_path + '/orders').gsub('//', '/')), as: :admin
end
