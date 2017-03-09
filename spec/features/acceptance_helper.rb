require 'selenium-webdriver'
require 'capybara/webkit/matchers'
require 'capybara/poltergeist'
require 'puma'
require 'capybara/email/rspec'

RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include I18nMacros, type: :feature
  config.include Warden::Test::Helpers, type: :feature
  config.include Capybara::Webkit::RspecMatchers, type: :feature

  # Poltergeist
  Capybara.register_driver :poltergeist do |app|
    # Set to log all javascript console messages to file
    Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs_logger: File.open('log/test_phantomjs.log', 'a'))

    # Set to log all javascript console messages to STDOUT
    #Capybara::Poltergeist::Driver.new(app, js_errors: false)
  end
  Capybara.javascript_driver = :poltergeist
  Capybara.current_driver = :poltergeist
  Capybara.default_driver = :poltergeist

  # Puma server
  Capybara.server = :puma
end

Capybara::Webkit.configure do |config|
  #config.block_unknown_urls
  config.allow_url("https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700&lang=en")
  config.allow_url("https://fonts.googleapis.com/css?family=Roboto:400,300,500,700")
end