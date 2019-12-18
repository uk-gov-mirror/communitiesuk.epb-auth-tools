# frozen_string_literal: true

require 'jwt'

module Auth
  class TokenProcessor
    def initialize(jwt_secret, jwt_issuer)
      @jwt_secret = jwt_secret
      @jwt_issuer = jwt_issuer
    end

    def process(token)
      payload, _header = jwt_process token

      raise Auth::Errors::TokenHasNoIssuer unless payload.key?('iss')
      unless payload['iss'] == @jwt_issuer
        raise Auth::Errors::TokenIssuerIncorrect
      end

      Auth::Token.new payload
    end

    private

    def jwt_process(token)
      options = { algorithm: 'HS256', iss: @jwt_issuer }

      JWT.decode token, @jwt_secret, true, options
    rescue JWT::ExpiredSignature
      raise Auth::Errors::TokenExpired
    rescue JWT::VerificationError
      raise Auth::Errors::TokenTamperDetected
    rescue JWT::DecodeError
      raise Auth::Errors::TokenDecodeError
    end
  end
end
