# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'epb_auth_tools'
  s.version = '0.0.0'
  s.date = '2019-12-04'
  s.summary = 'Tools for authentication and authorisation with JWTs and OAuth'
  s.authors = [
    'Lawrence Goldstien <lawrence.goldstien@madetech.com>',
    'Yusuf Sheikh <yusuf@madetech.com>',
    'Jaseera <jaseera@madetech.com>'
  ]
  s.files = %w[lib/epb_auth_tools.rb]
  s.add_runtime_dependency 'jwt', ['~> 2.2']
  s.add_runtime_dependency 'oauth2', ['~> 1.4']
  s.require_paths = %w[lib]
end
