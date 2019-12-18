# frozen_string_literal: true

module Auth
  require_relative 'token'
  require_relative 'token_processor'

  require_relative 'sinatra/conditional'

  module Errors
    class Error < RuntimeError; end

    class TokenPayloadError < Auth::Errors::Error; end
    class TokenExpired < Auth::Errors::TokenPayloadError; end
    class TokenNotYetValid < Auth::Errors::TokenPayloadError; end
    class TokenHasNoIssuer < Auth::Errors::TokenPayloadError; end
    class TokenHasNoSubject < Auth::Errors::TokenPayloadError; end
    class TokenHasNoIssuedAt < Auth::Errors::TokenPayloadError; end
    class TokenHasNoExpiry < Auth::Errors::TokenPayloadError; end
    class TokenIssuerIncorrect < Auth::Errors::TokenPayloadError; end

    class TokenDecodeError < Auth::Errors::Error; end
    class TokenTamperDetected < Auth::Errors::TokenDecodeError; end
  end
end
