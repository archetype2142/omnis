module Admin
  class Home::ApplicationController < ::ApplicationController
    before_action :authenticate_user!
  end
end