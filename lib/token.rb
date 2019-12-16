# frozen_string_literal: true

module Auth
  class Token
    def initialize(payload)
      @payload = payload
      validate_payload
    end

    def scope?(scope)
      @payload['scopes'].include? scope
    end

    def scopes?(scopes)
      scopes.all? { |scope| @payload['scopes'].include? scope }
    end

    private

    def validate_payload
      raise Auth::TokenInstantiatedWithoutIssuer unless @payload.key?('iss')
    end
  end

  class TokenInstantiatedWithoutIssuer < StandardError; end
end
