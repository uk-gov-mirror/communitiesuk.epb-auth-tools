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

      raise Auth::TokenHasWrongIssuer unless payload['iss'] == @jwt_issuer
      raise Auth::TokenMissingIatAttribute unless payload.key?('iat')
      raise Auth::TokenNotYetValid unless payload['iat'] <= Time.now.to_i
      raise Auth::TokenHasNoSubject unless payload.key?('sub')

      Auth::Token.new payload
    end

    private

    def jwt_process(token)
      options = { algorithm: 'HS256', iss: @jwt_issuer }

      JWT.decode token, @jwt_secret, true, options
    rescue JWT::ExpiredSignature
      raise Auth::TokenExpired
    rescue JWT::VerificationError
      raise Auth::TokenTamperDetected
    rescue JWT::DecodeError
      raise Auth::TokenMalformed
    end
  end

  class TokenMalformed < JWT::DecodeError; end

  class TokenExpired < JWT::ExpiredSignature; end

  class TokenHasWrongIssuer < JWT::InvalidIssuerError; end

  class TokenNotYetValid < JWT::InvalidIatError; end

  class TokenMissingIatAttribute < JWT::InvalidIatError; end

  class TokenHasNoSubject < StandardError; end

  class TokenTamperDetected < JWT::VerificationError; end
end
