module Api
  module V1
    module Admin
      class AdminController < BaseController
        before_action :require_admin

        private
        def require_admin
          return if api_current_user&.admin?

          raise ExceptionHandler::Unauthorized
        end
      end
    end
  end
end
