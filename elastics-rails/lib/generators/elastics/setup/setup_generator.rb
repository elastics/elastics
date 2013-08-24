class Elastics::SetupGenerator < Rails::Generators::Base

  source_root File.expand_path('../templates', __FILE__)

  def self.banner
    "rails generate elastics:setup"
  end

  def ask_base_name
    @module_name   = Prompter.ask('Please, enter a class name for your Search class. Choose a name not defined in your app.',
                                  :default => 'Elasticsearch', :hint => '[<enter>=Elasticsearch]')
    @extender_name = "#{@module_name}Extender"
  end

  def add_config_elastics_file
    template 'elastics_config.yml', Rails.root.join('config', 'elastics.yml')
  end

  def create_initializer_file
    template 'elastics_initializer.rb.erb', Rails.root.join('config', 'initializers', 'elastics.rb')
  end

  def create_elastics_dir
    template 'elastics_dir/elastics.rb.erb',          Rails.root.join('app', 'elastics', "#{@module_name.underscore}.rb")
    template 'elastics_dir/elastics.yml.erb',         Rails.root.join('app', 'elastics', "#{@module_name.underscore}.yml")
    template 'elastics_dir/elastics_extender.rb.erb', Rails.root.join('app', 'elastics', "#{@extender_name.underscore}.rb")
  end


  def show_setup_message
    Prompter.say <<-text, :style => :green

    Setup done!

    During prototyping, remember also:

      1. each time you include a new Elastics::ModelIndexer
         you should add its name to the config.elastics_model in "config/initializers/elastics.rb"

      2. each time you include a new Elastics::ActiveModel
         you should add its name to the config.elastics_active_model in "config/initializers/elastics.rb"

      3. each time you add/change a elastics.parent relation you should reindex

    The complete documentation is available at https://github.com/elastics/elastics-doc/doc
    If you have any problem with Elastics, please report the issue at https://github.com/elastics/elastics/issues.
    text
  end

end

