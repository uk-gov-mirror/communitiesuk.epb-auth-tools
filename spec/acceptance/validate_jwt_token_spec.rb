# frozen_string_literal: true
require 'jwt'
require 'rspec'

require_relative '../../lib/token'
require_relative '../spec_helper'

describe Auth::Token do
  before do
    @jwt_secret = 'thisisa32charactersecretstring!!'
    @jwt_issuer = 'test.issuer'
    @malformed_token = Base64.encode64('I am all wrong')
    @incorrect_issuer_token = token_generate @jwt_secret, 'not.an.issuer'
    @expired_token = token_generate @jwt_secret, @jwt_issuer, Time.now.to_i - 60 * 60
  end

  context 'when a token is malformed' do
    it 'does throw an Auth::TokenMalformed Error' do
      token = Auth::Token.new @jwt_secret, @jwt_issuer

      expect do
        token.process @malformed_token
      end.to raise_error(instance_of(Auth::TokenMalformed))
    end
  end

  context 'when a token has a different issuer' do
    it 'does throw an Auth::WrongIssuer Error' do
      token = Auth::Token.new @jwt_secret, @jwt_issuer

      expect do
        token.process @incorrect_issuer_token
      end.to raise_error(instance_of(Auth::WrongIssuer))
    end
  end

  context 'when a token has expired' do
    it 'does throw an Auth::TokenExpired Error' do
      token = Auth::Token.new @jwt_secret, @jwt_issuer
      puts @expired_token
      expect do
        token.process @expired_token
      end.to raise_error(instance_of(Auth::TokenExpired))
    end
  end
end


