module Elastics
  module Rails
    class Engine < ::Rails::Engine

      ActiveSupport.on_load(:before_configuration) do
        config.elastics = Conf
        config.elastics.variables[:index] = [self.class.name.split('::').first.underscore, ::Rails.env].join('_')
        config.elastics.config_file       = ::Rails.root.join('config', 'elastics.yml').to_s
        config.elastics.elastics_dir      = ::Rails.root.join('app', 'elastics').to_s
        config.elastics.logger            = Logger.new(STDOUT)
        config.elastics.logger.level      = ::Logger::DEBUG if ::Rails.env.development?
        config.elastics.result_extenders |= [ Elastics::Result::RailsHelper ]
      end

      ActiveSupport.on_load(:after_initialize) do
        Helper.after_initialize
      end

      rake_tasks do
        Elastics::LIB_PATHS.each do |path|
          task_path = "#{path}/tasks.rake"
          load task_path if File.file?(task_path)
        end
      end

      console do
        config.elastics.logger.log_to_rails_logger = false
        config.elastics.logger.log_to_stderr       = true
        config.elastics.logger.debug_variables     = false
        config.elastics.logger.debug_result        = false
        ::El = Elastics unless defined?(::El)
      end

      config.to_prepare do
        Elastics.reload!
      end

    end
  end
end
