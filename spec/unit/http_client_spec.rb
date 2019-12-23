require 'rspec'

describe Auth::HttpClient do
  context 'given incorrect initial values' do
    it 'raises Auth::Errors::ClientHasNoClientId when no client_id' do
      expect {
        Auth::HttpClient.new
      }.to raise_error instance_of Auth::Errors::ClientHasNoClientId
    end

    it 'raises Auth::Errors::ClientHasNoClientSecret with no client_secret' do
      expect {
        Auth::HttpClient.new 'client-id'
      }.to raise_error instance_of Auth::Errors::ClientHasNoClientSecret
    end

    it 'raises Auth::Errors::ClientHasNoAuthServer with no auth_server' do
      expect {
        Auth::HttpClient.new 'client-id', 'client-secret'
      }.to raise_error instance_of Auth::Errors::ClientHasNoAuthServer
    end
  end
end
