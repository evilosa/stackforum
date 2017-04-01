source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.0.1'
gem 'bootstrap-sass', '~> 3.3.7'
gem 'font-awesome-rails', '4.7.0.1'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0.4'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'slim-rails'
gem 'devise'
gem 'bootsy'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'sprockets', '3.6.3'
gem 'skim'
gem 'gon'
gem 'i18n-js', '>= 3.0.0.rc11'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'whenever'
gem 'mysql2', '~> 0.3.18', :platform => :ruby
gem 'thinking-sphinx'
gem 'will_paginate'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'therubyracer'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'database_cleaner'
  gem 'capybara-webkit'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'letter_opener'
  gem 'json_spec'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 3.1'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'launchy'
  gem 'with_model'
  gem 'capybara-email'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
