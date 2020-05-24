module Spree
  module Api
    module V1
      class AdminApiKeysController < ApplicationController
        def index
          admin_key = Spree::Role.find_by(name: 'admin').users.last.spree_api_key
          puts admin_key

          render json: Hash(key: admin_key)
        end
      end
    end
  end
end