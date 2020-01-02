# frozen_string_literal: true
module OAuth2Stub
  class Client
    def initialize(client_id, client_secret, options); end

    def client_credentials
      OAuth2Stub::ClientCredentials.new
    end
  end

  class ClientCredentials
    # rubocop:disable Naming/AccessorMethodName
    def get_token
      OAuth2Stub::AuthenticatedClient.new
    end
    # rubocop:enable Naming/AccessorMethodName
  end

  class AuthenticatedClient
    def expired?
      false
    end

    def get(url)
      get_response url
    end

    def post(url)
      get_response url
    end

    def put(url)
      get_response url
    end

    private

    def get_response(url)
      return normal_response unless url.include? 'expired'

      expired_response
    end

    def normal_response
      OAuth2::Response.new Faraday::Response.new status: 200,
                                                 reason_phrase: 'OK',
                                                 response_headers: {},
                                                 body: {}
    end

    def expired_response
      OAuth2::Response.new Faraday::Response.new status: 401,
                                                 reason_phrase: 'Unauthorized',
                                                 response_headers: {},
                                                 body: {
                                                   error:
                                                     'Auth::Errors::TokenExpired'
                                                 }
    end
  end
end
