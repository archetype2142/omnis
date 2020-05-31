module Spree
  module Api
    module V1
      class ClientsController < ApplicationController
        def index
          client = params[:q].to_s
          array = Address.where(
            "firstname ilike ? OR
            lastname ilike ? OR
            company ilike ?", "%#{client}%", "%#{client}%", "%#{client}%"
          ).limit(10).map do |a|
            [a.id, a.company.nil? ? a.firstname + ' ' + a.lastname : a.company]
          end

          render json: Hash[(0...array.size).zip array]
        end
      end
    end
  end
end