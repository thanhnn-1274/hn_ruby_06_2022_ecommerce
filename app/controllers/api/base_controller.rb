module Api
  class BaseController < ActionController::API
    include Pagy::Backend
    include ExceptionHandler
    include UsersHelper

    protected

    def authenticate_user
      token = request.headers["auth-token"]
      user_id = JsonWebToken.decode(token)["user_id"] if token
      user = User.find_by! id: user_id
      raise ExceptionHandler::AuthenticationError unless user
    end
  end
end
