# frozen_string_literal: true

# Exposes API for interacting with login/logout.
class SessionsController < ApplicationController
  include JwtAuth
  skip_before_action :find_user_by_token, only: [:create]
  skip_after_action :set_auth_token, only: [:destroy]

  def create
    user = User.find_by(email: login_params[:email])
    @current_user = user if user.authenticate(login_params[:password])
    render json: UserSerializer.new(@current_user).serializable_hash
  end

  def destroy
    response.set_header 'HTTP_ACCESS_TOKEN', ''
    render json: {}, status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
