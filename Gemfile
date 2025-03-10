source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.6'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'

gem 'base64', '~> 0.1.0'


gem 'redis', '~> 4.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false
gem 'cocoon'
gem 'devise', '~> 4.0'
gem 'rack-cors'
gem 'slim-rails'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-vkontakte'
gem "omniauth-rails_csrf_protection"
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers', '~> 0.10'
gem 'oj' #этот гем нужен для оптимизации превращения в json
gem 'sidekiq' # движек для отложенных задач
gem 'sinatra', require: false #добавляет Web интерфейс для gem sidekiq
gem 'whenever', require: false #добавляет приятный синтаксис для планировщика задач
gem 'mysql2',          '~> 0.4',    :platform => :ruby # нужен для работы gem 'thinking-sphinx'
gem 'thinking-sphinx', '~> 5.5' # движек для полнотекстового поиска 
gem 'database_cleaner-active_record'
gem 'unicorn'


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 6.1.0'
  gem "letter_opener"
  gem 'capybara-email'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'

  gem 'capistrano', require: false  
  # gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm'
  # gem 'capistrano-rbenv', '~> 2.2'
  gem 'capistrano-rails', require: false 
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  # gem 'selenium-webdriver', '~> 4.18.1'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '~> 6.0'
  gem 'webdrivers'
end
