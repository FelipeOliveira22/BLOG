require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module BlogMaino
  class Application < Rails::Application
    config.load_defaults 8.0

    # Configurações de localização e fuso horário
    config.i18n.default_locale = :'pt-BR'
    config.i18n.available_locales = [ :'pt-BR', :en ]
    config.time_zone = "Brasilia"

    # Ignorar subdiretórios específicos na lib
    config.autoload_lib(ignore: %w[assets tasks])
  end
end
