source 'https://rubygems.org'
ruby '2.5.0'

gem 'rails',            '4.2.8'
gem 'burgundy',         '~> 0.2'
gem 'devise',           '~> 4.0'
gem 'fast_attributes',  '~> 0.7'
gem 'figaro',           '~> 1.0'
gem 'foundation-rails', '~> 6.1.2'
gem 'high_voltage',     '~> 2.3'
gem 'jquery-rails',     '~> 4.0'
gem 'kaminari',         '~> 0.16.3'
gem 'lean-params',      github: 'lleolin/lean-params'
gem 'money-rails',      '~> 1.6'
gem 'pg',               '~> 0.18'
gem 'public_activity',  '~> 1.4'
gem 'pundit',           '~> 1.0'
gem 'rollbar',          '~> 2.8'
gem 'sass-rails',       '~> 5.0'
gem 'sendgrid',         '~> 1.2'
gem 'sidekiq',          '~> 3.3'
gem 'simple_form',      '~> 3.2'
gem 'slim-rails',       '~> 3.0'
gem 'statesman',        '~> 2.0'
gem 'sucker_punch',     '~> 2.0'
gem 'uglifier',         '~> 2.7'
gem 'wisper',           '~> 1.6'

source 'https://rails-assets.org' do
  gem 'rails-assets-foundation-datepicker'
  gem 'rails-assets-jquery'
end

group :development do
  gem 'better_errors'
  gem 'guard-bundler',              require: false
  gem 'guard-livereload', '~> 2.4', require: false
  gem 'guard-pow',                  require: false
  gem 'guard-rspec',                require: false
  gem 'letter_opener', '~> 1.4'
  gem 'quiet_assets'
  gem 'rack-livereload'
  gem 'rails_layout'
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'spring-commands-rspec'
  gem 'web-console', '~> 2.0'
end

group :development, :test do
  gem 'byebug',             '~> 5.0'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'faker',              '~> 1.4'
  gem 'pry-rails',          '~> 0.3'
  gem 'pry-rescue',         '~> 1.4'
  gem 'rspec-rails',        '~> 3.2'
  gem 'spring',             '~> 1.3'
  gem 'thin',               '~> 1.6'
end

group :production do
  gem 'puma', '~> 3.2'
end

group :test do
  gem 'capybara',             '~> 2.4'
  gem 'capybara-screenshot',  '~> 1.0'
  gem 'database_cleaner',     '~> 1.4'
  gem 'launchy',              '~> 2.4'
  gem 'poltergeist',          '~> 1.6'
  gem 'simplecov',            '~> 0.10',  require: false
  gem 'site_prism',           '~> 2.8',   require: false
  gem 'timecop',              '~> 0.8'
end
