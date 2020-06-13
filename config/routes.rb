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
    root to: "orders#index"
    post 'upload_products_csv', to: 'products#upload_products_csv'
    
    resources :products, only: [:index, :show, :new, :create, :update] do
      resources :images, only: [:index, :create, :destroy]
      resources :prices, only: [:index, :create, :destroy]
    end
    
    resources :orders, only: [:index, :new, :show, :destroy]

    namespace :customers do
      resources :clients, only: [:index, :create, :show, :update, :destroy]
      resources :companies, only: [:index, :create]
      resources :addresses, only: [:index, :create, :update, :destroy, :show]
      resources :orders, only: [:index]
    end
  end

  spree_path = Rails.application.routes.url_helpers.try(:spree_path, trailing_slash: true) || '/'
  get Spree.admin_path, to: redirect((spree_path + Spree.admin_path + '/orders').gsub('//', '/')), as: :admin
end
