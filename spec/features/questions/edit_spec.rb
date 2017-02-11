feature 'Edit question', %q{
  In order to fix mistake
  As an author
  I want to be able edit question
} do

  scenario 'Unauthenticated user tries edit question'
  describe 'Authenticated user' do
    scenario 'sees link to edit his question'
    scenario 'not sees link to edit other user''s question'
    scenario 'tries edit his question'
    scenario 'tries to edit other user''s question'
  end
end