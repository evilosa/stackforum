RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question_with_answers) }
  let!(:answer) { question.answers[0] }

  let!(:destroy_request) do
    Proc.new do |params = { id: answer, question_id: question } |
      delete :destroy, params: params
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    it 'deletes answer' do
      expect { destroy_request.call }.to change(question.answers, :count).by(-1)
    end

    it 'redirect to question' do
      destroy_request.call
      expect(response).to redirect_to question
    end
  end
end