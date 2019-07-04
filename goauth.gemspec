# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'goauth/version'

Gem::Specification.new do |spec|
  spec.name          = 'goauth'
  spec.version       = Goauth::VERSION
  spec.authors       = ['Jakub Głuszecki']
  spec.email         = ['jakub.gluszecki@gmail.com']

  spec.summary       = 'GoAuth client'
  spec.description   = 'GoAuth client'
  spec.homepage      = 'http://go.intami.pl/'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'

  spec.add_dependency 'faraday', '~> 0.15'
  spec.add_dependency 'hashie', '~> 3.6'
end
