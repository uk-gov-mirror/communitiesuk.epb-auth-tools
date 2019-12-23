require 'rspec'

describe Auth::HttpClient do
  context 'given incorrect initial values' do
    it 'raises a Auth::Errors::ClientHasNoClientId' do
      expect {
        Auth::HttpClient.new nil
      }.to raise_error instance_of Auth::Errors::ClientHasNoClientId
    end
  end
end
