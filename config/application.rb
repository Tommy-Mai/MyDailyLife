require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MyDailyLife
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # 開発環境に「development」と書かれたリボンを表示
    config.rack_dev_mark.enable = !Rails.env.production?

    # 以下、2行タイムゾーンを日本時間に変更
    config.time_zone = 'Tokyo' # Time.zone.nowとかの時に日本時間を使用する
    config.active_record.default_timezone = :local # DBの読み書きを日本時間でやる

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
