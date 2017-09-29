require 'rails/all'

Bundler.require(*Rails.groups)

module GroceryGuruServer
  class Application < Rails::Application
    config.load_defaults 5.1

    config.to_prepare do
      Devise::Mailer.send(:include, Roadie::Rails::Automatic)
      Devise::Mailer.layout 'mailer' #specify the layout
      # Devise::Mailer.helper 'email' #only if needed!
    end
  end
end
