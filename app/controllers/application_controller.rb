class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :basic_auth

private

  def basic_auth
    return unless ENV['HEROKER_USERNAME'] && ENV['HEROKER_PASSWORD']

    authenticate_or_request_with_http_basic do |user, pass|
      [user, pass] == [ENV['HEROKER_USERNAME'], ENV['HEROKER_PASSWORD']]
    end
  end

end
