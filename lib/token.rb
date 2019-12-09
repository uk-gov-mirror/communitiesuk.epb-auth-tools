# frozen_string_literal: true

require 'jwt'

module Auth
  class Token
    def initialize(jwt_secret, jwt_issuer)
      @jwt_secret = jwt_secret
      @jwt_issuer = jwt_issuer
    end

    def process(token)
      payload, _header = jwt_process token

      raise Auth::WrongIssuer unless payload['iss'] == @jwt_issuer
    end

    private

    def jwt_process(token)
      options = { algorithm: 'HS256', iss: @jwt_issuer }

      JWT.decode token, @jwt_secret, true, options
    rescue JWT::DecodeError
      raise Auth::TokenMalformed
    end
  end

  class TokenMalformed < JWT::DecodeError
  end

  class WrongIssuer < JWT::InvalidIssuerError
  end
end
