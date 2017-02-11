feature 'Set best answer', %q{
  In order to set best answer
  As question author
  I want to be able set best answer
} do

  scenario 'Unauthenticated user tries to set best answer'

  describe 'Authenticated user' do
    scenario 'sees link to set best answer'
    scenario 'not sees link to set best answer for other user''s question'
    scenario 'set best answer for his question'
    scenario 'change best answer for his question'
  end
end