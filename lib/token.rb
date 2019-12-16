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

    private

    def validate_payload
      unless @payload.key?('iss')
        raise Auth::TokenErrors::InstantiatedWithoutIssuer
      end
      unless @payload.key?('sub')
        raise Auth::TokenErrors::InstantiatedWithoutSubject
      end
      unless @payload.key?('iat')
        raise Auth::TokenErrors::InstantiatedWithoutIssuedAt
      end
    end
  end

  module TokenErrors
    class Error < StandardError; end
    class InstantiatedWithoutIssuer < Auth::TokenErrors::Error; end
    class InstantiatedWithoutSubject < Auth::TokenErrors::Error; end
    class InstantiatedWithoutIssuedAt < Auth::TokenErrors::Error; end
  end
end
