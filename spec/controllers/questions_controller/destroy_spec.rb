RSpec.describe QuestionsController, type: :controller do
  let!(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    sign_in_user

    it 'deletes question' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      question
      expect { delete :destroy, params: { id: question }}.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
