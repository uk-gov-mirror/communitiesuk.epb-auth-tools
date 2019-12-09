require 'jwt'
require 'uuid'

def uuid_generate
  uuid = UUID.new
  uuid.generate
end

def token_generate(secret, payload)
  JWT.encode payload, secret, 'HS256'
end
