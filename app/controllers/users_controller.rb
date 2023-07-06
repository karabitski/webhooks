# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :get_user_by_token, only: [:create]

  before_action { @organization = Organization.find(params[:organization_id]) }

  def create
    @user = @organization.users.build(users_params)
    if @user.save
      render json: UserSerializer.new(@user).serializable_hash, status: :created
    else
      render json: { errors: @user.errors.full_messages, status: 422 }
    end
  end

  private

  def users_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
