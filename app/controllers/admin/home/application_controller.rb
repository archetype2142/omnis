module Admin
  class Home::ApplicationController < ::ApplicationController
    before_action :authenticate_spree_user!
  end
end