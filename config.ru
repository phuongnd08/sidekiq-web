require 'sidekiq'
require 'sidekiq/web'

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_SIDEKIQ'] }
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['SIDEKIQ_USER'] || "admin", ENV['SIDEKIQ_PASSWORD'] || "secret"]
end

run Sidekiq::Web
