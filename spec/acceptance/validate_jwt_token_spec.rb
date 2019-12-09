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

    @incorrect_issuer_token =
      token_generate @jwt_secret,
                     exp: Time.now.to_i + 60 * 60,
                     iat: Time.now.to_i,
                     iss: 'incorrect.issuer',
                     sub: uuid_generate,
                     scopes: %w[scope:1 scope:2 scope:3]

    @expired_token =
      token_generate @jwt_secret,
                     exp: Time.now.to_i - 60 * 60,
                     iat: Time.now.to_i,
                     iss: @jwt_issuer,
                     sub: uuid_generate,
                     scopes: %w[scope:1 scope:2 scope:3]

    @premature_token =
      token_generate @jwt_secret,
                     exp: Time.now.to_i + 60 * 60,
                     iat: Time.now.to_i + 30 * 60,
                     iss: @jwt_issuer,
                     sub: uuid_generate,
                     scopes: %w[scope:1 scope:2 scope:3]

    @no_sub_token =
      token_generate @jwt_secret,
                     exp: Time.now.to_i + 60 * 60,
                     iat: Time.now.to_i,
                     iss: @jwt_issuer,
                     scopes: %w[scope:1 scope:2 scope:3]

    @valid_token =
      token_generate @jwt_secret,
                     exp: Time.now.to_i + 60 * 60,
                     iat: Time.now.to_i,
                     iss: @jwt_issuer,
                     sub: uuid_generate,
                     scopes: %w[scope:1 scope:2 scope:3]
  end

  context 'when a token is valid' do
    it 'does return an instance of Auth::Token' do
      expect(@token_processor.process(@valid_token)).to be_an_instance_of(
        Auth::Token
      )
    end

    it 'does allow checking a scope' do
      token = @token_processor.process @valid_token

      expect(token.scope?('scope:1')).to be true
    end

    it 'does allow checking a number of scopes' do
      token = @token_processor.process @valid_token

      expect(token.scopes?(%w[scope:1 scope:2])).to be true
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
        @token_processor.process @incorrect_issuer_token
      }.to raise_error(instance_of(Auth::TokenHasWrongIssuer))
    end
  end

  context 'when a token has expired' do
    it 'does throw an Auth::TokenExpired Error' do
      expect { @token_processor.process @expired_token }.to raise_error(
        instance_of(Auth::TokenExpired)
      )
    end
  end

  context 'when a token was issued in the future' do
    it 'does throw an Auth::TokenNotYetValid Error' do
      expect { @token_processor.process @premature_token }.to raise_error(
        instance_of(Auth::TokenNotYetValid)
      )
    end
  end

  context 'when a token does not have a subject' do
    it 'does throw an Auth::TokenHasNoSubject Error' do
      expect { @token_processor.process @no_sub_token }.to raise_error(
        instance_of(Auth::TokenHasNoSubject)
      )
    end
  end
end
