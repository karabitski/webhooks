# frozen_string_literal: true

class SessionsController < ApplicationController
  include JwtAuth
  skip_before_action :get_user_by_token, only: [:create]
  skip_after_action :set_auth_token, only: [:destroy]

  def create
    user = User.find_by(email: login_params[:email])
    if user.authenticate(login_params[:password])
      @current_user = user
    end
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