# Set default encodings
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# Configure Rails
Rails.application.configure do
  config.encoding = "utf-8"
  config.i18n.default_locale = :'zh-CN'
  config.time_zone = 'Beijing'
end
