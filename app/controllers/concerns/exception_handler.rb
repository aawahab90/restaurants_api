module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches `StandardErrors`
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    # Define custom handlers
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized_request
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  private

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  # JSON response with message; - Unauthorized
  def unauthorized_request(e)
    json_response({ status: { code: 1, error: 'unauthorized', message: e.message }}, :unauthorized)
  end

  def user_not_authorized
     json_response({ status: { code: 1, error: 'unauthorized', message: 'You are not authorized to perform this action.' }}, :unauthorized) 
  end
end