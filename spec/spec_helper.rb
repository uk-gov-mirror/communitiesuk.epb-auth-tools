require 'jwt'
require 'uuid'

def token_generate(secret, issuer, expiry_date = nil, issued_at_date = nil)
  uuid = UUID.new
  expiry_date = Time.now.to_i + 60 * 60 if expiry_date.nil?
  issued_at_date = Time.now.to_i if issued_at_date.nil?

  JWT.encode(
    {
      exp: expiry_date,
      iat: issued_at_date,
      iss: issuer,
      sub: uuid.generate,
      scopes: %w[scope:1 scope:2]
    },
    secret,
    'HS256'
  )
end
