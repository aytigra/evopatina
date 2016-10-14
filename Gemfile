source 'https://rubygems.org'
ruby '2.3.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'activeadmin', '~> 1.0.0.pre4'
gem 'devise'
gem 'slim'
gem 'slim-rails'
gem 'ranked-model'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
#gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby

gem 'bootstrap-sass', '~> 3.3.3'
#gem 'momentjs-rails', '>= 2.8.1'
#gem 'bootstrap3-datetimepicker-rails', '~> 4.0.0'
gem 'bootstrap-datepicker-rails'
gem 'growlyflash'
gem 'nprogress-rails'
gem 'js-routes', github: 'railsware/js-routes'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'js_cookie_rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# external services
gem 'rollbar'
gem 'postmark-rails'

group :development do
  gem 'guard-rspec'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'thin'
  gem 'factory_girl_rails'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'ruby_gntp'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'
  gem 'site_prism'
  gem 'database_cleaner'
  gem 'faker'
  gem 'simplecov', require: false
  gem 'webmock'
end
