# frozen_string_literal: true

# Base class for all controllers
class ApplicationController < ActionController::Base
  include JwtAuth
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :find_user_by_token
  after_action  :set_auth_token

  helper_method :current_user
  helper_method :current_token

  def current_user
    @current_user ||= find_user_by_token
  end

  def current_token
    @current_token ||= request.headers['http-access-token']
  end

  def authorize
    render(json: { error: '401 Unauthorized access' }, status: :unauthorized) if current_user.nil?
  end

  def check_access
    render(json: { error: '403 Forbidden' }, status: :forbidden) if current_user.organization_id != @organization.id
  end

  private

  def find_user_by_token
    payload = decode_jwt current_token
    return nil if Time.zone.at(payload[:exp]) < Time.zone.now

    @current_user = User.find_by(id: payload[:user_id])
  rescue StandardError
    nil
  end

  def set_auth_token
    return unless current_user

    token = current_token || encode_jwt(user_id: current_user.id)
    response.set_header 'HTTP_ACCESS_TOKEN', token
  end

  def not_found
    render json: { error: 'Not Found' }, status: :not_found
  end
end

# TODO: fix ffi gem install
# LDFLAGS="-L/usr/local/opt/libffi/lib" PKG_CONFIG_PATH="/usr/local/opt/libffi/lib/pkgconfig"  gem install ffi -v '1.15.5' --source 'https://rubygems.org/'
