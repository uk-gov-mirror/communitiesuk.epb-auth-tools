# frozen_string_literal: true

module Auth
  class HttpClient
    def initialize(client_id)
      raise Auth::Errors::ClientHasNoClientId if client_id.nil?
    end
  end
end
