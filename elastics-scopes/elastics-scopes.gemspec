require 'date'
version_path = %w[../VERSION ../../VERSION].detect{|v| File.exist?(File.expand_path(v, __FILE__))}
version      = File.read(File.expand_path(version_path, __FILE__)).strip

Gem::Specification.new do |s|
  s.name                      = 'elastics-scopes'
  s.summary                   = 'ActiveRecord-like chainable scopes and finders for Elastics.'
  s.description               = 'Provides an easy to use ruby API to search elasticsearch with ActiveRecord-like chainable and mergeables scopes.'
  s.homepage                  = 'http://elastics.github.io/elastics'
  s.authors                   = ["Domizio Demichelis"]
  s.email                     = 'dd.nexus@gmail.com'
  s.files                     = `git ls-files -z`.split("\0") + %w[VERSION LICENSE]
  s.version                   = version
  s.date                      = Date.today.to_s
  s.required_rubygems_version = ">= 1.3.6"
  s.rdoc_options              = %w[--charset=UTF-8]
  s.license                   = 'MIT'

  s.add_runtime_dependency 'elastics-client', version
end
