module ExceptionHandler
  extend ActiveSupport::Concern
  class LoginFailed < StandardError; end

  class AuthenticationError < StandardError; end

  class Unauthorized < StandardError; end

  class InvalidVerification < StandardError; end

  included do
    rescue_from ExceptionHandler::InvalidVerification,
                with: :invalid_verification
    rescue_from ExceptionHandler::LoginFailed, with: :login_failed_response
    rescue_from ExceptionHandler::AuthenticationError,
                with: :authentication_failed_response
    rescue_from ExceptionHandler::Unauthorized, with: :unauthorized_response
    rescue_from ActiveRecord::RecordInvalid,
                with: :render_unprocessable_entity_response
    rescue_from ActiveRecord::RecordNotFound,
                with: :render_record_not_found_response
    rescue_from CanCan::AccessDenied, with: :access_denied
  end

  private

  def render_unprocessable_entity_response error, status: :unprocessable_entity
    render json: Errors::ActiveRecordValidation.new(
      error.record
    ).to_hash, status: status
  end

  def render_record_not_found_response error, status: :not_found
    render json: Errors::ActiveRecordNotFound.new(
      error
    ).to_hash, status: status
  end

  def login_failed_response error, status: :unprocessable_entity
    render json: Errors::MessageError.new(error).to_hash, status: status
  end

  def authentication_failed_response error, status: :unauthorized
    render json: Errors::MessageError.new(error).to_hash, status: status
  end

  def unauthorized_response error, status: :unauthorized
    render json: Errors::MessageError.new(error).to_hash, status: status
  end

  def invalid_verification error, status: :unauthorized
    render json: Errors::MessageError.new(error).to_hash, status: status
  end

  def access_denied error, status: :unauthorized
    render json: Errors::MessageError.new(error).to_hash, status: status
  end
end
