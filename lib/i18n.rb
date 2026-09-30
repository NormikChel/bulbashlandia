require 'yaml'

module I18n
  LOCALES = %w[ru be be-latn en uk].freeze
  DEFAULT = 'ru'
  DATA = {}

  def self.load!
    LOCALES.each do |loc|
      DATA[loc] = YAML.load_file(File.expand_path("../i18n/#{loc}.yml", __dir__))
    end
  end

  def self.valid?(loc)
    LOCALES.include?(loc.to_s)
  end

  def self.t(key, locale = DEFAULT)
    keys = key.to_s.split('.')
    DATA.dig(locale, *keys) || DATA.dig(DEFAULT, *keys) || key
  end

  # Плоский доступ для шаблонов: только то, что нужно
  def self.hash(locale = DEFAULT)
    DATA[locale] || DATA[DEFAULT]
  end
end

I18n.load!