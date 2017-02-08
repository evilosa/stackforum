module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in t('activerecord.attributes.user.email'), with: user.email
    fill_in t('activerecord.attributes.user.password'), with: user.password
    click_button t('common.button.log_in')
    wait_for_ajax
  end
end