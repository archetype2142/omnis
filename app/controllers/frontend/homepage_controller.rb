module Frontend
  class HomepageController < ::ApplicationController
    layout 'no_navbar_application'
    protect_from_forgery with: :null_session

    def index; end
  end
end
