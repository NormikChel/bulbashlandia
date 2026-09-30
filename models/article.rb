class Article < Sequel::Model(:articles)
  plugin :timestamps, update_on_create: true
  plugin :validation_helpers

  CATEGORIES = %w[history culture cuisine nature people].freeze

  def validate
    validates_presence [:title, :slug, :category]
    validates_unique :slug
    validates_includes CATEGORIES, :category, message: "одна из: #{CATEGORIES.join(', ')}"
    validates_format /\A[a-z0-9-]+\z/, :slug, message: 'только строчные латинские буквы, цифры и дефис'
  end

  def localized_title(locale = 'ru')
    case locale.to_s
    when 'be'      then title_be      || title
    when 'be-latn' then title_latn    || title_be || title
    when 'en'      then title_en      || title
    when 'uk'      then title_uk      || title
    else title
    end
  end

  def localized_body(locale = 'ru')
    case locale.to_s
    when 'be'      then body_be      || body
    when 'be-latn' then body_latn    || body_be || body
    when 'en'      then body_en      || body
    when 'uk'      then body_uk      || body
    else body
    end
  end

  def reading_time(locale = 'ru')
    words = localized_body(locale).to_s.split.size
    [(words / 180.0).ceil, 1].max
  end

  def self.published
    where(published: true).order(Sequel.desc(:created_at)).all
  end

  def self.in_category(category)
    where(category: category, published: true).order(Sequel.desc(:created_at)).all
  end

  def self.latest(limit = 5)
    where(published: true).order(Sequel.desc(:created_at)).limit(limit).all
  end
end