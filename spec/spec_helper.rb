require 'jwt'
require 'uuid'

def token_generate(secret, issuer)
  uuid = UUID.new

  JWT.encode({
    exp: Time.now.to_i + 60 * 60,
    iat: Time.now.to_i,
    iss: issuer,
    sub: uuid.generate,
    scopes: %w[scope:1 scope:2]
  }, secret, 'HS256')
end
