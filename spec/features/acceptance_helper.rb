RSpec.configure do |config|
  config.include AcceptanceHelper, type: :feature
  config.include I18nMacros, type: :feature

  Capybara.javascript_driver = :webkit

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
  end
end

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.timeout = 5
end