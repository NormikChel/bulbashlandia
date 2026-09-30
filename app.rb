require 'sinatra'

set :bind, '0.0.0.0'
set :port, ENV['PORT'] || 3000

get '/' do
  "<h1>Привет с Discloud!</h1><p>Ruby работает 🎉</p>"
end