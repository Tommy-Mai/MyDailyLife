# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.8'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.4'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  gem 'rspec-rails', '~> 3.7'

  gem 'factory_bot_rails', '~> 4.11'

  gem 'database_cleaner'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'spring-watcher-listen', '~> 2.0.0'

  # 以下、手動で追加
  # errorをみやすくするgem
  gem 'better_errors'

  gem 'binding_of_caller'

  # コーディング規約に準拠してるかチェックするgem
  gem 'rubocop', require: false

  gem 'rubocop-performance', require: false

  gem 'rubocop-rails', require: false

  gem 'rubocop-rspec'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'

  gem 'selenium-webdriver'

  # Easy installation and use of chromedriver to run system tests with Chrome
  # gem 'chromedriver-helper'
  gem 'webdrivers', '~> 3.0'

  gem "rspec"

  gem "rspec_junit_formatter"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# 以下、手動で追加するgem

# Slim
gem 'slim-rails'

gem 'html2slim'

# 開発環境に「development」と書かれたリボンを表示させて、本番と間違えないようにするgem
gem 'rack-dev-mark'

# font-awesome
gem 'font-awesome-sass'

# デバック用gem
gem 'pry-rails'
gem 'pry-byebug'

# カレンダー作成gem
gem 'simple_calendar', '~> 2.0'

# 初期データ・テスト用データの投入gem
gem 'seed-fu'

# jQuery導入
gem 'jquery-rails'

# テキスト内のリンクを自動検出
gem 'rinku'

# 検索機能のためのgem
gem 'ransack'

# ページネーションのためのgem
gem 'kaminari'

# 環境変数管理gem
gem 'dotenv-rails'

# ER図作成用gem
group :development, :test do
  gem 'rails-erd'
end

# Slack通知用gem
gem 'slack-api'
