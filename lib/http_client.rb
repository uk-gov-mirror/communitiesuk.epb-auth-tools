# frozen_string_literal: true

require 'oauth2'

module Auth
  class HttpClient
    attr_reader :authenticated_client

    def initialize(
      client_id = nil,
      client_secret = nil,
      auth_server = nil,
      base_uri = nil,
      auth_client = OAuth2::Client
    )
      raise Auth::Errors::ClientHasNoClientId if client_id.nil?
      raise Auth::Errors::ClientHasNoClientSecret if client_secret.nil?
      raise Auth::Errors::ClientHasNoAuthServer if auth_server.nil?
      raise Auth::Errors::ClientHasNoBaseUri if base_uri.nil?

      @base_uri = base_uri
      @client =
        auth_client.new client_id,
                        client_secret,
                        site: auth_server, raise_errors: false
    end

    def refresh
      @authenticated_client = @client.client_credentials.get_token
    end

    def refresh?
      @authenticated_client.nil? || @authenticated_client.expired?
    end

    def self.delegate(*methods)
      methods.each do |method_name|
        define_method(method_name) do |*args, &block|
          request method_name, *args, &block
        end
      end
    end

    delegate :get, :post, :put

    def request(method_name, *args, &block)
      refresh? && refresh

      args[0] = @base_uri + args[0]

      if @authenticated_client.respond_to? method_name
        response = @authenticated_client.send method_name, *args, &block
        if response.body.is_a?(::Hash) &&
             response.body[:error] == 'Auth::Errors::TokenExpired'
          refresh
          response = @authenticated_client.send method_name, *args, &block
        end

        response
      end
    rescue Faraday::ConnectionFailed
      raise Auth::Errors::NetworkConnectionFailed
    end
  end
end
