require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq-failures'

Sidekiq.configure_client do |config|
  option = { url: ENV['REDIS_SIDEKIQ'] }
  option[:namespace] = ENV["REDIS_SIDEKIQ_NAMESPACE"] if ENV["REDIS_SIDEKIQ_NAMESPACE"]
  config.redis = option
end

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['SIDEKIQ_USER'] || "admin", ENV['SIDEKIQ_PASSWORD'] || "secret"]
end

run Sidekiq::Web
