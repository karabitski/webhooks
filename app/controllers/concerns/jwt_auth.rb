# frozen_string_literal: true

# Exposes common methods to deal with jwt token
module JwtAuth
  extend ActiveSupport::Concern

  def decode_jwt(token)
    return nil if token.blank?

    decoded_token = JWT.decode token, Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }
    decoded_token[0].deep_symbolize_keys
  end

  def encode_jwt(payload)
    payload[:exp] = 24.hours.from_now.to_i
    payload[:iat] = Time.now.to_i
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end
end
