# frozen_string_literal: true
require 'token'

describe Auth::Token do
  context 'when instantiating a token without an issuer' do
    it 'it raises an Auth::TokenErrors::InstantiatedWithoutIssuer Error' do
      expect {
        Auth::Token.new token_payload(:missing_issuer_token)
      }.to raise_error(
        instance_of(Auth::TokenErrors::InstantiatedWithoutIssuer)
      )
    end
  end

  context 'when instantiating a token without a subject' do
    it 'it raises an Auth::TokenErrors::InstantiatedWithoutSubject Error' do
      expect {
        Auth::Token.new token_payload(:missing_sub_token)
      }.to raise_error(
        instance_of(Auth::TokenErrors::InstantiatedWithoutSubject)
      )
    end
  end

  context 'when instantiating a token without an issued at time' do
    it 'it raises an Auth::TokenErrors::InstantiatedWithoutIssuedAt Error' do
      expect {
        Auth::Token.new token_payload(:missing_issued_at_token)
      }.to raise_error(
        instance_of(Auth::TokenErrors::InstantiatedWithoutIssuedAt)
      )
    end
  end
end
