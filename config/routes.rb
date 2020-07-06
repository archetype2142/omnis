require 'sidekiq/web'

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
  
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == 'test' && password == 'test'
  end
  mount Sidekiq::Web => '/sidekiq'

  Spree::Core::Engine.add_routes do
    get "/sale" => "home#sale"
    
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
    root to: "homepage#index"
    post 'upload_products_csv', to: 'products#upload_products_csv'
    
    resources :orders, only: [:index, :new, :show, :destroy]

    namespace :customers do
      resources :clients, only: [:index, :create, :show, :update, :destroy]
      # resources :companies, only: [:index, :create]
      resources :addresses, only: [:index, :create, :update, :destroy, :show]
      resources :orders, only: [:index, :update]
    end

    resources :customers do
      resources :companies, only: [:index, :create], controller: "customers/companies"
      resources :subsidiaries, only: [:index, :create], controller: "customers/subsidiaries"
      resources :stores, only: [:index, :create], controller: "customers/stores"
      resources :prices, controller: "customers/prices", only: [:index, :new, :edit, :update, :destroy]
    end

    resources :products, only: [:index, :show, :new, :create, :update] do
      resources :images, only: [:index, :create, :destroy, :show, :update]
      resources :prices, only: [:index, :create, :edit, :new, :destroy, :update]
      resources :stocks, only: [:index, :create, :edit, :new, :destroy, :update]
      resources :variants, only: [:index, :create, :show, :new, :destroy, :update]
      resources :variants_stock, only: [:update]
    end

    resources :option_types, only: [:index, :update, :show, :destroy, :new, :create] do 
      resources :option_values, only: [:create, :destroy, :update]
    end
    match '/option_types/update_position', to: 'option_types#update_option_position', via: :post
  end

  spree_path = Rails.application.routes.url_helpers.try(:spree_path, trailing_slash: true) || '/'
  get Spree.admin_path, to: redirect((spree_path + Spree.admin_path + '/orders').gsub('//', '/')), as: :admin
end
