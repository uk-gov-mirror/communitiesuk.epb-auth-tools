# frozen_string_literal: true

require_relative '../spec_helper'
require 'token_processor'
require 'token'

describe Auth::TokenProcessor do
  before do
    @jwt_secret = 'thisisa32charactersecretstring!!'
    @jwt_issuer = 'test.issuer'

    @token_processor = Auth::TokenProcessor.new @jwt_secret, @jwt_issuer

    @malformed_token = Base64.encode64 'I am all wrong'
  end

  context 'when a token is valid' do
    it 'does return an instance of Auth::Token' do
      expect(
        @token_processor.process(token_generate(@jwt_secret, :valid_token))
      ).to be_an_instance_of(Auth::Token)
    end

    it 'does allow checking a scope' do
      token = @token_processor.process token_generate(@jwt_secret, :valid_token)

      expect(token.scope?('scope:1')).to be true
      expect(token.scope?('does-not-exist')).to be false
    end

    it 'does allow checking a number of scopes' do
      token = @token_processor.process token_generate(@jwt_secret, :valid_token)

      expect(token.scopes?(%w[scope:1 scope:2])).to be true
      expect(token.scope?(%w[scope:1 does-not-exist])).to be false
    end
  end

  context 'when a token is not a JWT token' do
    it 'does throw an Auth::TokenMalformed Error' do
      expect { @token_processor.process @malformed_token }.to raise_error(
        instance_of(Auth::TokenMalformed)
      )
    end
  end

  context 'when a token has a different issuer' do
    it 'does throw an Auth::TokenHasWrongIssuer Error' do
      expect {
        @token_processor.process token_generate(
                                   @jwt_secret,
                                   :incorrect_issuer_token
                                 )
      }.to raise_error(instance_of(Auth::TokenHasWrongIssuer))
    end
  end

  context 'when a token has expired' do
    it 'does throw an Auth::TokenExpired Error' do
      expect {
        @token_processor.process token_generate(@jwt_secret, :expired_token)
      }.to raise_error(instance_of(Auth::TokenExpired))
    end
  end

  context 'when a token was issued in the future' do
    it 'does throw an Auth::TokenNotYetValid Error' do
      expect {
        @token_processor.process token_generate(@jwt_secret, :premature_token)
      }.to raise_error(instance_of(Auth::TokenNotYetValid))
    end
  end

  context 'when a token does not have a subject' do
    it 'does throw an Auth::TokenHasNoSubject Error' do
      expect {
        @token_processor.process token_generate(@jwt_secret, :no_sub_token)
      }.to raise_error(instance_of(Auth::TokenHasNoSubject))
    end
  end

  context 'when a token has been edited after generation' do
    it 'does throw an Auth::TokenTamperDetection Error' do
      expect {
        jwt = token_generate(@jwt_secret, :valid_token)
        jwt = jwt.split('.')
        payload = JSON.parse Base64.decode64 jwt[1]
        payload['scopes'] = %w[admin:*]
        jwt[1] = Base64.encode64 payload.to_json

        @token_processor.process jwt.join('.')
      }.to raise_error(instance_of(Auth::TokenTamperDetected))
    end
  end
end
