require 'sidekiq/web'

Sidekiq::Web.use Rack::Auth::Basic do |user, password|
  user == ENV['SIDEKIQ_USER'] && password == ENV['SIDEKIQ_PASSWORD']
end
