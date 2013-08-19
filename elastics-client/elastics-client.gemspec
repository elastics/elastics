require 'date'
version = File.read(File.expand_path('../VERSION', __FILE__)).strip

Gem::Specification.new do |s|
  s.name                      = 'elastics-client'
  s.summary                   = 'Client gem for elasticsearch'
  s.description               = 'Core gem used by all the elastics gems.'
  s.homepage                  = 'http://elastics.github.io/elastics'
  s.authors                   = ['Domizio Demichelis']
  s.email                     = 'dd.nexus@gmail.com'
  s.require_paths             = %w[lib]
  s.files                     = `git ls-files -z`.split("\0")
  s.version                   = version
  s.date                      = Date.today.to_s
  s.required_rubygems_version = '>= 1.3.6'
  s.rdoc_options              = %w[--charset=UTF-8]
  s.license                   = 'MIT'
  s.post_install_message      = <<EOM
________________________________________________________________________________

                             ELASTICS INSTALLATION NOTES
________________________________________________________________________________

New Documentation:  http://elastics.github.io/elastics

Upgrading Tutorial: http://elastics.github.io/elastics/doc/7-Tutorials/2-Migrate-from-0.x.html

________________________________________________________________________________
EOM
  s.add_runtime_dependency     'multi_json',  '>= 1.3.4'
  s.add_runtime_dependency     'progressbar', '>= 0.11.0', '~> 0.12.0'
  s.add_runtime_dependency     'dye',         '~> 0.1.4'
end
