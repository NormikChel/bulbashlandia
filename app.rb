require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'
require_relative 'lib/i18n'

DB = Sequel.sqlite('db/database.sqlite3')
require_relative 'models/city'
require_relative 'models/article'

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 3000
set :views, 'views'
set :public_folder, 'public'

# Определяем локаль из URL/куки/заголовка
before do
  @locale =
    if I18n.valid?(params[:lang]) then params[:lang]
    elsif I18n.valid?(request.cookies['lang']) then request.cookies['lang']
    else
      al = request.env['HTTP_ACCEPT_LANGUAGE'].to_s
      al.scan(/[a-z]{2}(-[a-z]{2,4})?/i).flatten.find { |c| I18n.valid?(c.downcase.split('-').first) }&.split('-')&.first || 'ru'
    end
  response.set_cookie('lang', value: @locale, path: '/', max_age: 31_536_000)
  @t    = I18n.hash(@locale)
  @lang = @locale
  @canonical = "#{request.base_url}/#{@locale}/"
end

# Хелпер для ссылок с сохранением языка
helpers do
  def l(path = '/')
    "/#{@lang}#{path.start_with?('/') ? path : "/#{path}"}"
  end
end

# Редирект с корня на локаль
get '/' do
  redirect "/#{@locale}/"
end

# Все страницы принимают :lang
get '/:lang/?' do
  pass unless I18n.valid?(params[:lang])
  @cities = City.order(:name).limit(6).all
  erb :index
end

get '/:lang/cities/?' do
  pass unless I18n.valid?(params[:lang])
  @cities = City.order(:name).all
  erb :'cities/list'
end

get '/:lang/cities/:slug/?' do
  pass unless I18n.valid?(params[:lang])
  @city = City.first(slug: params[:slug]) or halt(404, 'Город не найден')
  erb :'cities/show'
end

get '/:lang/about/?' do
  pass unless I18n.valid?(params[:lang])
  erb :about
end

not_found do
  erb :'404', layout: false
end