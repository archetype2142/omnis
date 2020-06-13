module Admin
  class Home::HomepageController < ::Home::ApplicationController
    before_action :authenticate_spree_user!
    
    def index; end
  end
end