require 'elastics-client'
require 'elastics-models'
require 'rails'
require 'elastics/result/rails_helper'
require 'elastics/rails/helper'
require 'elastics/rails/logger'

Elastics::LIB_PATHS << File.dirname(__FILE__)

if ::Rails.respond_to?(:version) && ::Rails.version.to_i >= 3
  require 'elastics/rails/engine'
else
  Elastics::Conf.configure do |c|
    c.config_file       = "#{RAILS_ROOT}/config/elastics.yml"
    c.elastics_dir      = "#{RAILS_ROOT}app/elastics"
    c.logger            = Logger.new(STDOUT)
    c.logger.level      = ::Logger::DEBUG if RAILS_ENV == 'development'
    c.result_extenders |= [ Elastics::Result::RailsHelper ]
  end
end
