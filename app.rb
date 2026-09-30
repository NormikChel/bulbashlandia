# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'
require_relative 'lib/i18n'
require_relative 'lib/manifest'
require_relative 'lib/sw'
require_relative 'lib/browserconfig'
require_relative 'lib/rss'
require_relative 'lib/atom'

# --- 1. Соединение с БД (до моделей!) ---
DB_PATH = File.expand_path('db/database.sqlite3', __dir__)
DB = Sequel.sqlite(DB_PATH)
Sequel::Model.db = DB

# --- 2. Автмиграция при старте ---
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
set :show_exceptions, false
set :raise_errors, false

# --- 4. Статика и служебные файлы без языковой логики ---
before do
  pass if request.path_info.start_with?(
    '/css/', '/js/', '/img/', '/favicon.ico',
    '/robots.txt', '/sitemap.xml',
    '/manifest.webmanifest', '/manifest.json',
    '/sw.js', '/browserconfig.xml'
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
    path = path.sub(%r{\A/}, '')
    path = path.sub(%r{/\z}, '')
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

  # Текущий путь без языкового префикса.
  # '/ru/cities'          → '/cities'
  # '/be-latn/articles/x' → '/articles/x'
  # '/ru'                 → ''
  def path_without_locale
    request.path_info.sub(%r{\A/[A-Za-z-]+(?=/|\z)}, '')
  end

  # Элементы для RSS/Atom фидов
  def feed_items
    Article.published.first(20).map do |a|
      {
        title:       a.localized_title(@locale),
        link:        "#{request.base_url}/#{@locale}/articles/#{a.slug}",
        description: a.excerpt.to_s,
        date:        a.created_at,
        category:    a.category
      }
    end
  end
end

# --- 7. Редирект с корня на локаль ---
get '/' do
  redirect "/#{@locale}", 302
end

# --- 8. Страницы с локалью ---
get '/:lang' do
  pass unless I18n.valid?(params[:lang])
  @cities   = City.order(:name).limit(6).all
  @articles = Article.published.first(3)
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
  @page_title = "#{@city.localized_name(@locale)} — #{@t.dig('meta', 'site_name')}"
  @canonical  = "#{request.base_url}/#{@locale}/cities/#{@city.slug}"
  erb :'cities/show'
end

get '/:lang/articles' do
  pass unless I18n.valid?(params[:lang])
  @articles = Article.published
  erb :'articles/list'
end

get '/:lang/articles/:slug' do
  pass unless I18n.valid?(params[:lang])
  @article = Article.first(slug: params[:slug], published: true)
  halt 404, 'Статья не найдена' unless @article
  @page_title = "#{@article.localized_title(@locale)} — #{@t.dig('meta', 'site_name')}"
  @canonical  = "#{request.base_url}/#{@locale}/articles/#{@article.slug}"
  erb :'articles/show'
end

get '/:lang/about' do
  pass unless I18n.valid?(params[:lang])
  @page_title = "#{@t.dig('nav', 'about') || 'О проекте'} — #{@t.dig('meta', 'site_name')}"
  @canonical  = "#{request.base_url}/#{@locale}/about"
  erb :about
end

# --- 9. Служебные файлы ---
get '/robots.txt' do
  content_type 'text/plain'
  <<~TXT
    User-agent: *
    Allow: /

    Sitemap: #{request.base_url}/sitemap.xml
  TXT
end

get '/sitemap.xml' do
  content_type 'application/xml; charset=utf-8'
  base = request.base_url
  urls = []
  I18n::LOCALES.each do |loc|
    urls << "#{base}/#{loc}"
    urls << "#{base}/#{loc}/cities"
    urls << "#{base}/#{loc}/about"
    City.all.each { |c| urls << "#{base}/#{loc}/cities/#{c.slug}" }
    Article.published.each { |a| urls << "#{base}/#{loc}/articles/#{a.slug}" }
  end
  body = urls.map { |u| "  <url><loc>#{Rack::Utils.escape_html(u)}</loc></url>" }.join("\n")
  <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
    #{body}
    </urlset>
  XML
end

# --- 9.5. PWA: манифест, service worker, browserconfig ---
get '/manifest.webmanifest' do
  content_type 'application/manifest+json; charset=utf-8'
  cache_control :public, max_age: 3600
  Manifest.render(locale: @locale, t: @t)
end

get '/manifest.json' do
  redirect '/manifest.webmanifest', 301
end

get '/sw.js' do
  content_type 'application/javascript; charset=utf-8'
  headers 'Service-Worker-Allowed' => '/'
  cache_control :public, max_age: 0
  ServiceWorker.render
end

get '/browserconfig.xml' do
  content_type 'application/xml; charset=utf-8'
  cache_control :public, max_age: 86_400
  BrowserConfig.render
end

# --- 9.6. Фиды RSS и Atom ---
get '/:lang/rss.xml' do
  pass unless I18n.valid?(params[:lang])
  content_type 'application/rss+xml; charset=utf-8'
  cache_control :public, max_age: 3600
  RSSFeed.render(locale: @locale, t: @t, base_url: request.base_url, items: feed_items)
end

get '/:lang/atom.xml' do
  pass unless I18n.valid?(params[:lang])
  content_type 'application/atom+xml; charset=utf-8'
  cache_control :public, max_age: 3600
  AtomFeed.render(locale: @locale, t: @t, base_url: request.base_url, items: feed_items)
end

# --- 9.7. favicon ---
get '/favicon.ico' do
  file = File.join(settings.public_folder, 'favicon.ico')
  halt 404 unless File.exist?(file)
  send_file file
end

# --- 10. 404 и 500 ---
not_found do
  @locale    ||= 'ru'
  @t         ||= I18n.hash(@locale)
  @lang      ||= @locale
  @canonical ||= "#{request.base_url}/#{@locale}"
  @page_title = "#{@t.dig('errors', 'not_found_title')} — #{@t.dig('meta', 'site_name')}"
  status 404
  erb :'404'
end

error do
  e = env['sinatra.error']
  warn "[500] #{e.class}: #{e.message}\n#{Array(e.backtrace).first(8).join("\n")}"
  @locale    ||= 'ru'
  @t         ||= I18n.hash(@locale)
  @lang      ||= @locale
  @canonical ||= "#{request.base_url}/#{@locale}"
  @page_title = "#{@t.dig('errors', 'server_title')} — #{@t.dig('meta', 'site_name')}"
  status 500
  erb :'404'
end