require 'date'
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name                      = 'elastics-rails'
  s.summary                   = 'Rails integration for Elastics'
  s.description               = 'Provides the engine, generators and helpers to integrate Elastics with Rails'
  s.homepage                  = 'http://elastics.github.io/elastics'
  s.authors                   = ["Domizio Demichelis"]
  s.email                     = 'dd.nexus@gmail.com'
  s.files                     = `git ls-files -z`.split("\0")
  s.version                   = version
  s.date                      = Date.today.to_s
  s.required_rubygems_version = ">= 1.3.6"
  s.rdoc_options              = %w[--charset=UTF-8]
  s.license                   = 'MIT'

  s.add_runtime_dependency 'rails', '>=2.0'

  s.add_runtime_dependency 'elastics-client',        version
  s.add_runtime_dependency 'elastics-models', version

  s.add_runtime_dependency 'prompter', '~> 0.1.5'
end
