RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question_with_owner_answers, user: user) }
  let!(:answer) { question.answers[0] }

  let!(:destroy_request) do
    Proc.new do |params = { id: answer, question_id: question } |
      delete :destroy, params: params, format: :js
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes answer' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      expect { destroy_request.call }.to change(question.answers, :count).by(-1)
    end

    it 'render template destroy' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      destroy_request.call
      expect(response).to render_template :destroy
    end
  end
end