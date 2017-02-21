module SeleniumMacros
  def use_selenium_webdriver
    before(:all) do
      Capybara.javascript_driver = :selenium
      Capybara.current_driver = :selenium
    end

    after(:all) do
      Capybara.current_driver = :poltergeist
      Capybara.javascript_driver = :poltergeist
    end
  end
end