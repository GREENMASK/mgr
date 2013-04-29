module ShellyDependencies
  if ENV['SHELLYCLOUD_DEPLOYMENT']
    if defined?(Rails) && Rails.version >= "3.0.0"
      class Engine < Rails::Engine
        initializer "shelly-dependencies.serve_static_assets" do |app|
          app.config.serve_static_assets = true
        end

        if Rails.version >= "3.1.0"
          initializer "shelly-dependencies.assets.compile" do |app|
            app.config.assets.compile = true
          end
        end
      end
    end
  end
end
