# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'
require_relative 'lib/i18n'

# --- 1. Соединение с БД (до моделей!) ---
DB_PATH = File.expand_path('db/database.sqlite3', __dir__)
DB = Sequel.sqlite(DB_PATH)
Sequel::Model.db = DB

# --- 2. Автмиграция при старте ---
# Пригодится на Render: если база пустая или отсутствует — создастся и накатится.
Sequel.extension :migration
MIGRATIONS_PATH = File.expand_path('db/migrate', __dir__)
if Dir.exist?(MIGRATIONS_PATH) && !Dir.children(MIGRATIONS_PATH).empty?
  begin
    Sequel::Migrator.run(DB, MIGRATIONS_PATH)
  rescue Sequel::Error => e
    warn "[migrator] #{e.class}: #{e.message}"
  end
end

# --- 3. Модели (только после установки соединения) ---
require_relative 'models/city'
require_relative 'models/article'

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 3000
set :views, 'views'
set :public_folder, 'public'

# --- 4. Статика и служебные файлы без языковой логики ---
before do
  pass if request.path_info.start_with?(
    '/css/', '/js/', '/img/', '/favicon.ico',
    '/robots.txt', '/sitemap.xml'
  )
end

# --- 4.5. Убираем хвостовой слэш (кроме корня) — 301 на канонический URL ---
before do
  path = request.path_info
  if path.length > 1 && path.end_with?('/')
    qs     = request.query_string
    target = path.chomp('/')
    target = "#{target}?#{qs}" unless qs.empty?
    redirect target, 301
  end
end

# --- 5. Определение локали ---
# В before-фильтре params[:lang] недоступен (роуты ещё не сматчены),
# поэтому берём первый сегмент пути вручную.
before do
  path_locale   = request.path_info.split('/').reject(&:empty?).first
  cookie_locale = request.cookies['lang']
  header_locale = request.env['HTTP_ACCEPT_LANGUAGE'].to_s
                        .scan(/[a-z]{2}/i).map(&:downcase)
                        .find { |c| I18n.valid?(c) }

  @locale =
    if I18n.valid?(path_locale)
      path_locale
    elsif I18n.valid?(cookie_locale)
      cookie_locale
    else
      header_locale || 'ru'
    end

  response.set_cookie('lang', value: @locale, path: '/', max_age: 31_536_000)
  @t         = I18n.hash(@locale)
  @lang      = @locale
  @canonical = "#{request.base_url}/#{@locale}"
end

# --- 6. Хелперы ---
helpers do
  # Ссылка с сохранением текущей локали. Без хвостового слэша.
  def l(path = '')
    path = path.to_s
    path = path.sub(%r{\A/}, '') # убираем ведущий слэш, если есть
    path = path.sub(%r{/\z}, '') # убираем хвостовой слэш, если есть
    path.empty? ? "/#{@lang}" : "/#{@lang}/#{path}"
  end

  # Экранирование HTML
  def h(text)
    Rack::Utils.escape_html(text.to_s)
  end

  # Плоский доступ к строке словаря: t('nav.home') → @t['nav']['home']
  def t(key)
    parts = key.to_s.split('.')
    @t.dig(*parts) || I18n.hash('ru').dig(*parts) || key
  end
end

# --- 7. Редирект с корня на локаль ---
get '/' do
  redirect "/#{@locale}", 302
end

# --- 8. Страницы с локалью ---
get '/:lang' do
  pass unless I18n.valid?(params[:lang])
  @cities = City.order(:name).limit(6).all
  erb :index
end

get '/:lang/cities' do
  pass unless I18n.valid?(params[:lang])

  q = params[:q].to_s.strip
  @cities = q.empty? ? City.order(:name).all : City.search(q, @locale)
  @query  = q
  erb :'cities/list'
end

get '/:lang/cities/:slug' do
  pass unless I18n.valid?(params[:lang])
  @city = City.first(slug: params[:slug])
  halt 404, 'Город не найден' unless @city
  @articles = Article.published.first(3)
  erb :'cities/show'
end

get '/:lang/about' do
  pass unless I18n.valid?(params[:lang])
  erb :about
end

# --- 9. Служебные файлы ---
get '/robots.txt' do
  content_type 'text/plain'
  "User-agent: *\nAllow: /\nSitemap: #{request.base_url}/sitemap.xml\n"
end

get '/favicon.ico' do
  file = File.join(settings.public_folder, 'favicon.ico')
  halt 404 unless File.exist?(file)
  send_file file
end

# --- 10. 404 и 500 ---
not_found do
  @locale ||= 'ru'
  @t      ||= I18n.hash(@locale)
  @lang   ||= @locale
  status 404
  erb :'404', layout: false
end

error do
  e = env['sinatra.error']
  warn "[500] #{e.class}: #{e.message}\n#{Array(e.backtrace).first(8).join("\n")}"
  @locale ||= 'ru'
  @t      ||= I18n.hash(@locale)
  @lang   ||= @locale
  erb :'404', layout: false
end