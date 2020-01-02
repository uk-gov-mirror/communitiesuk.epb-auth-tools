# frozen_string_literal: true

require 'oauth2'

module Auth
  class HttpClient
    attr_reader :authenticated_client

    def initialize(
      client_id = nil,
      client_secret = nil,
      auth_server = nil,
      auth_client = OAuth2::Client
    )
      raise Auth::Errors::ClientHasNoClientId if client_id.nil?
      raise Auth::Errors::ClientHasNoClientSecret if client_secret.nil?
      raise Auth::Errors::ClientHasNoAuthServer if auth_server.nil?

      @client = auth_client.new client_id, client_secret, site: auth_server
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

      if @authenticated_client.respond_to? method_name
        response = @authenticated_client.send method_name, *args, &block

        if response.body[:error] == 'Auth::Errors::TokenExpired'
          refresh
          response = @authenticated_client.send method_name, *args, &block
        end

        response
      end
    end
  end
end
