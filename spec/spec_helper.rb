require 'jwt'
require 'uuid'

def uuid_generate
  uuid = UUID.new
  uuid.generate
end

def token_payload(payload)
  @jwt_issuer = 'test.issuer'

  payloads = {
    incorrect_issuer_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': 'incorrect.issuer',
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3]
    },
    expired_token: {
      'exp': Time.now.to_i - 60 * 60,
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3]
    },
    premature_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i + 30 * 60,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3]
    },
    missing_issued_at_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3]
    },
    missing_sub_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'scopes': %w[scope:1 scope:2 scope:3]
    },
    missing_issuer_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3]
    },
    valid_token: {
      'exp': Time.now.to_i + 60 * 60,
      'iat': Time.now.to_i,
      'iss': @jwt_issuer,
      'sub': uuid_generate,
      'scopes': %w[scope:1 scope:2 scope:3]
    }
  }

  payloads[payload]
end

def token_generate(secret, payload)
  JWT.encode token_payload(payload), secret, 'HS256'
end
