# frozen_string_literal: true

module Auth
  class Token
    def initialize(payload)
      @payload = JSON.parse payload.to_json
      validate_payload
    end

    def scope?(scope)
      @payload['scopes'].include? scope
    end

    def scopes?(scopes)
      scopes.all? { |scope| @payload['scopes'].include? scope }
    end

    def encode(jwt_secret)
      JWT.encode @payload, jwt_secret, 'HS256'
    end

    private

    def validate_payload
      raise Auth::Errors::TokenHasNoIssuer unless @payload.key?('iss')
      raise Auth::Errors::TokenHasNoIssuedAt unless @payload.key?('iat')
      unless @payload['iat'] <= Time.now.to_i
        raise Auth::Errors::TokenNotYetValid
      end
      raise Auth::Errors::TokenHasNoSubject unless @payload.key?('sub')
    end
  end
end
