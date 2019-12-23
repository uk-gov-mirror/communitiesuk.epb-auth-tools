# frozen_string_literal: true

module Auth
  class HttpClient
    def initialize(client_id = nil, client_secret = nil, auth_server = nil)
      raise Auth::Errors::ClientHasNoClientId if client_id.nil?
      raise Auth::Errors::ClientHasNoClientSecret if client_secret.nil?
      raise Auth::Errors::ClientHasNoAuthServer if auth_server.nil?
    end
  end
end
