feature 'Edit answer', %q{
  In order to fix mistake
  As an author
  I want to be able edit answer
} do

  scenario 'Unauthenticated user tries edit answer'
  describe 'Authenticated user' do
    scenario 'sees link to edit his answer'
    scenario 'not sees link to edit other user''s answer'
    scenario 'tries edit his answer'
    scenario 'tries to edit other user''s answer'
  end
end