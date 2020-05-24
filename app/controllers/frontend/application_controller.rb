module Frontend
  class ApplicationController < ::ApplicationController::Base
    protect_from_forgery with: :null_session
  end
end
