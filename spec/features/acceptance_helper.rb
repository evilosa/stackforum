require 'selenium-webdriver'
require 'capybara/webkit/matchers'
require 'capybara/poltergeist'

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include I18nMacros, type: :feature
  config.include Warden::Test::Helpers, type: :feature
  config.include Capybara::Webkit::RspecMatchers, type: :feature

  Capybara.register_driver :poltergeist do |app|
    # Set to log all javascript console messages to file
    Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs_logger: File.open('log/test_phantomjs.log', 'a'))

    # Set to log all javascript console messages to STDOUT
    #Capybara::Poltergeist::Driver.new(app, js_errors: false)
  end

  #Capybara.javascript_driver = :selenium
  Capybara.javascript_driver = :poltergeist

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
    if Rails.env.test?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads"])
    end
  end
end

Capybara::Webkit.configure do |config|
  #config.block_unknown_urls
  config.allow_url("https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&lang=en")
  config.allow_url("https://fonts.googleapis.com/css?family=Roboto:400,300,500,700")
end