# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  include JwtAuth
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :get_user_by_token
  after_action  :set_auth_token

  helper_method :current_user
  helper_method :current_token

  def current_user
    @current_user ||= get_user_by_token
  end

  def current_token
    @current_token ||= request.headers['http-access-token']
  end

  def authorize
    render(json: { error: '401 Unauthorized access' }, status: :unauthorized) if @current_user.nil?
  end

  def check_access
    if @current_user.organization_id != @organization.id
      render(json: { error: '403 Forbidden' }, status: :forbidden)
    end
  end

  private

  def get_user_by_token
    begin
      payload = decode_jwt current_token
      return nil if Time.at(payload[:exp]) < Time.now
      @current_user = User.find_by(id: payload[:user_id])
    rescue
      nil
    end
  end

  def set_auth_token
    if current_user
      token = current_token || encode_jwt(user_id: current_user.id)
      response.set_header 'HTTP_ACCESS_TOKEN', token
    end
  end

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end



# TODO: fix ffi gem install
# LDFLAGS="-L/usr/local/opt/libffi/lib" PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"  gem install ffi -v '1.15.5' --source 'https://rubygems.org/'
