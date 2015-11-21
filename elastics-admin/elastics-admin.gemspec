require 'date'
version_path = %w[VERSION ../VERSION].detect{|v| File.exist?(v)}
version      = File.read(version_path).strip
extra_files  = []
extra_files << 'VERSION' if File.exist?('VERSION')
extra_files << 'LICENSE' if File.exist?('LICENSE')

Gem::Specification.new do |s|
  s.name                      = 'elastics-admin'
  s.summary                   = 'Dump/load/rename/live-redindex one or more elasticsearch indices and types.'
  s.description               = 'Provides binary and rake tasks to dump, load and optionally rename indices. Implements live-reindex with hot-swap of old code/index with new code/index.'
  s.homepage                  = 'http://elastics.github.io/elastics'
  s.authors                   = ["Domizio Demichelis"]
  s.email                     = 'dd.nexus@gmail.com'
  s.executables               = %w[elastics-admin]
  s.files                     = `git ls-files -z`.split("\0") + extra_files
  s.version                   = version
  s.date                      = Date.today.to_s
  s.required_rubygems_version = ">= 1.3.6"
  s.rdoc_options              = %w[--charset=UTF-8]
  s.license                   = 'MIT'

  s.add_runtime_dependency 'elastics-client', version
end
