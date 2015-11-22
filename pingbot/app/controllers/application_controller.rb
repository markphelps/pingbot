class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from ActionController::RoutingError, with: -> { render nothing: true, status: 404 }
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      @organization = Organization.where(token: token).first
    end
  end
end
