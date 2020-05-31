module Admin
  class ApplicationController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :authenticate_spree_user!

    layout 'layouts/application'
  end
end
