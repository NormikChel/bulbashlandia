class City < Sequel::Model(:cities)
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  # Псевдонимы для локали — чтобы в шаблоне писать `city.localized_name`
  LOCALES = %w[ru be be_latn en uk].freeze

  def validate
    validates_presence [:name, :slug, :region]
    validates_unique :slug
    validates_format /\A[a-z0-9-]+\z/, :slug, message: 'только строчные латинские буквы, цифры и дефис'
  end

  # Возвращает название города для указанной локали с фолбэком на русский
  def localized_name(locale = 'ru')
    case locale.to_s
    when 'be'      then name_be      || name
    when 'be-latn' then name_latn    || name_be || name
    when 'en'      then name_en      || name
    when 'uk'      then name_uk      || name
    else name
    end
  end

  def localized_region(locale = 'ru')
    case locale.to_s
    when 'be'      then region_be      || region
    when 'be-latn' then region_latn    || region_be || region
    when 'en'      then region_en      || region
    when 'uk'      then region_uk      || region
    else region
    end
  end

  def localized_description(locale = 'ru')
    case locale.to_s
    when 'be'      then description_be      || description
    when 'be-latn' then description_latn    || description_be || description
    when 'en'      then description_en      || description
    when 'uk'      then description_uk      || description
    else description
    end
  end

  # Для карточек и превью — первые N символов описания
  def excerpt(locale = 'ru', limit = 160)
    text = localized_description(locale).to_s
    return '' if text.empty?
    text.length > limit ? "#{text[0, limit].rstrip}…" : text
  end

  def formatted_population
    return nil unless population
    population.to_s.reverse.scan(/\d{1,3}/).join(' ').reverse
  end

  def capital?
    capital == true
  end

  def self.by_region(region)
    where(region: region).order(:name).all
  end

  def self.capitals
    where(capital: true).order(:name).all
  end

  def self.search(query, locale = 'ru')
    return order(:name).all if query.to_s.strip.empty?
    q = "%#{query.downcase}%"
    where(
      Sequel.ilike(:name, q) |
      Sequel.ilike(:name_be, q) |
      Sequel.ilike(:name_latn, q) |
      Sequel.ilike(:name_en, q) |
      Sequel.ilike(:name_uk, q)
    ).order(:name).all
  end
end