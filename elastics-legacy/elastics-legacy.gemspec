require 'date'
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name                      = 'elastics-legacy'
  s.summary                   = 'Adds legacy compatibility and deprecations warnings.'
  s.description               = 'Provides out-of-the box legacy compatibility (with flex and old versions). Use it for a smooth migration to the new gems.'
  s.homepage                  = 'http://elastics.github.io/elastics'
  s.authors                   = ["Domizio Demichelis"]
  s.email                     = 'dd.nexus@gmail.com'
  s.files                     = `git ls-files -z`.split("\0")
  s.version                   = version
  s.date                      = Date.today.to_s
  s.required_rubygems_version = ">= 1.3.6"
  s.rdoc_options              = %w[--charset=UTF-8]
  s.license                   = 'MIT'

  s.add_runtime_dependency 'elastics-client', version
end
