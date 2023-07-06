# frozen_string_literal: true

# Exposes API for interacting with Organizations.
class OrganizationsController < ApplicationController
  before_action :authorize
  before_action :find_organization
  before_action :check_access

  def show
    render json: OrganizationSerializer.new(@organization).serializable_hash
  end

  private

  def find_organization
    @organization = Organization.find(params[:id])
  end
end
