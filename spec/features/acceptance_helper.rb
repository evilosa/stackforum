require 'selenium-webdriver'

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include I18nMacros, type: :feature
  config.include WaitForAjax, type: :feature
  config.include Warden::Test::Helpers, type: :feature

  #Capybara.register_driver :selenium do |app|
  #  Capybara::Selenium::Driver.new(app, :browser => :firefox)
  #end

  Capybara.javascript_driver = :selenium

  #Capybara.javascript_driver = :webkit
  Capybara.default_max_wait_time = 10

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    Warden.test_reset!
  end
end

Capybara::Webkit.configure do |config|
  #config.block_unknown_urls
  config.allow_url("https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&lang=en")
  config.allow_url("https://fonts.googleapis.com/css?family=Roboto:400,300,500,700")
end