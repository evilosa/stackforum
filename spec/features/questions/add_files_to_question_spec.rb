require_relative '../selenium_helper'

feature 'Add files to question', %q{

  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do
  describe 'dfdf' do
    before(:all) do
      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app, browser: :firefox)
      end
      Capybara.javascript_driver = :selenium
      Capybara.current_driver = :selenium
    end

    given(:user) { create(:user) }

    background do
      login_as(user, scope: :user, run_callbacks: false)
      visit new_question_path
    end

    scenario 'User adds file when asks question', js: true do
      fill_in t('activerecord.attributes.question.title'), with: 'Test question'
      page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test body';")

      inputs = all('.select-file')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")

      click_on t('common.button.create')

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end

    scenario 'User adds some files when asks question', js: true do
      fill_in t('activerecord.attributes.question.title'), with: 'Test question'
      page.execute_script("$('.wysihtml5-sandbox')[0].contentWindow.document.body.innerHTML='Test body';")

      click_on t('common.button.attachment.add')

      inputs = all('.select-file')
      inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
      inputs[1].set("#{Rails.root}/spec/spec_helper.rb")

      click_on t('common.button.create')

      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    end

    after(:all) do
      Capybara.use_default_driver
    end
  end
end