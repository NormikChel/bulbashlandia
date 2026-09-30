require 'yaml'

module I18n
  LOCALES = %w[ru be be-latn en uk zh-Hans zh-Hant].freeze
  DEFAULT = 'ru'
  DATA = {}

  def self.load!
    LOCALES.each do |loc|
      path = File.expand_path("../i18n/#{loc}.yml", __dir__)
      DATA[loc] = YAML.load_file(path)
    end
  end

  def self.valid?(loc)
    LOCALES.include?(loc.to_s)
  end

  def self.t(key, locale = DEFAULT)
    keys = key.to_s.split('.')
    DATA.dig(locale, *keys) || DATA.dig(DEFAULT, *keys) || key
  end

  def self.hash(locale = DEFAULT)
    DATA[locale] || DATA[DEFAULT]
  end
end

I18n.load!