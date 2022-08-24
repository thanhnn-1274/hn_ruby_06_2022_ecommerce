module Api
  module V1
    class AuthController < BaseController
      def sign_in
        user = User.find_by email: params[:email]
        unless user.valid_password? params[:password]
          raise ExceptionHandler::LoginFailed
        end

        render json: {
          auth_token: JsonWebToken.encode({user_id: user.id})
        }
      end

      private

      def auth_params
        params.permit(:email, :password)
      end
    end
  end
end
