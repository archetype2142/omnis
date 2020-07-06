module Admin
  class ApplicationController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :authenticate_spree_user!
    helper NavigationHelper
    
    layout 'layouts/application'
  end
end
