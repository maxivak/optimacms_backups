module OptimacmsBackups
  class Engine < ::Rails::Engine
    isolate_namespace OptimacmsBackups

    config.watchable_dirs['lib'] = [:rb] if Rails.env.development?
    #config.watchable_dirs['app/helpers'] = [:rb] if Rails.env.development?

    #config.autoload_paths << File.expand_path("../lib/some/path", __FILE__)
    #config.autoload_paths << File.expand_path("../lib/optimacms/path", __FILE__)

#    config.autoload_paths += Dir["#{OptimacmsBackups::Engine.root}/app/helpers/"]
#    config.autoload_paths += Dir["#{OptimacmsBackups::Engine.root}/app/helpers/**/"]



    config.autoload_paths += Dir["#{OptimacmsBackups::Engine.root}/lib/"]
    config.autoload_paths += Dir["#{OptimacmsBackups::Engine.root}/lib/**/"]

    #config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/concerns/"]
    #config.autoload_paths += Dir["#{Optimacms::Engine.root}/lib/concerns/**/"]

    config.autoload_paths += Dir["#{OptimacmsBackups::Engine.root}/lib/optimacms_backups/"]
    config.autoload_paths += Dir["#{OptimacmsBackups::Engine.root}/lib/optimacms_backups/**/"]

    #config.autoload_paths += Dir["#{config.root}/lib/**/"]
    #config.autoload_paths += Dir["#{config.root}/lib/"]
    #config.autoload_paths += Dir["#{config.root}/lib/**/*.rb"]


    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end



  end
end
