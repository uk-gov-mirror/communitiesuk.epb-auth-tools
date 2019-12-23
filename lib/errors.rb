# frozen_string_literal: true

module Auth
  module Errors
    class Error < RuntimeError; end

    class Token < Auth::Errors::Error; end

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

    class Client < Auth::Errors::Error; end

    class ClientHasNoClientId < Auth::Errors::Client; end

  end
end
