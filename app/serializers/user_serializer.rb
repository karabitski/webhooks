# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attributes :name, :email, :organization_id, :created_at, :updated_at
end
