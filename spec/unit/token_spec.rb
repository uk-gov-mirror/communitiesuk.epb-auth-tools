require 'token'

describe Auth::Token do

  context 'when instantiating a token without an issuer' do
    it 'it raises an Auth::TokenInstantiatedWithoutIssuer Error' do
      expect {
        Auth::Token.new token_payload(:missing_issuer_token)
      }.to raise_error(instance_of(Auth::TokenInstantiatedWithoutIssuer))
    end
  end
end
