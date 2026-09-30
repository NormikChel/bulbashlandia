class City < Sequel::Model(:cities)
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  LOCALES = %w[ru be be-latn en uk zh-Hans zh-Hant].freeze

  def validate
    validates_presence [:name, :slug, :region]
    validates_unique :slug
    validates_format /\A[a-z0-9-]+\z/, :slug, message: 'только строчные латинские буквы, цифры и дефис'
  end

  def localized_name(locale = 'ru')
    case locale.to_s
    when 'be'      then name_be      || name
    when 'be-latn' then name_latn    || name_be || name
    when 'en'      then name_en      || name
    when 'uk'      then name_uk      || name
    when 'zh-Hans' then name_zh_hans || name_en || name
    when 'zh-Hant' then name_zh_hant || name_en || name
    else name
    end
  end

  def localized_region(locale = 'ru')
    case locale.to_s
    when 'be'      then region_be      || region
    when 'be-latn' then region_latn    || region_be || region
    when 'en'      then region_en      || region
    when 'uk'      then region_uk      || region
    when 'zh-Hans' then region_zh_hans || region_en || region
    when 'zh-Hant' then region_zh_hant || region_en || region
    else region
    end
  end

  def localized_description(locale = 'ru')
    case locale.to_s
    when 'be'      then description_be      || description
    when 'be-latn' then description_latn    || description_be || description
    when 'en'      then description_en      || description
    when 'uk'      then description_uk      || description
    when 'zh-Hans' then description_zh_hans || description_en || description
    when 'zh-Hant' then description_zh_hant || description_en || description
    else description
    end
  end

  def localized_excerpt(locale = 'ru', limit = 160)
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
      Sequel.ilike(:name_uk, q) |
      Sequel.ilike(:name_zh_hans, q) |
      Sequel.ilike(:name_zh_hant, q)
    ).order(:name).all
  end
end