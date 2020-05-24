module Admin
  class ApplicationController < ApplicationController::Base
    protect_from_forgery with: :null_session
    before_action :authenticate_user!

    layout 'layouts/application'
  end
end
