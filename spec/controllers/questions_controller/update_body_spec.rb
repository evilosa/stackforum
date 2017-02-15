RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: @user) }

  let!(:update_body) do
    Proc.new do |body = 'new body'|
      patch :update_body, params: { question_id: question.id, question: { body: body} , format: :js }
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'changes question body' do
        patch :update_body, params: { question_id: question.id, question: { body: 'new body'}, format: :js }
        question.reload
        expect(question.body.html_safe).to eq 'new body'
      end

      it 'redirects to the updated question view' do
        update_body.call
        expect(response).to render_template :update_body
      end
    end

    context 'invalid attributes' do
      before { patch :update_body, params: { question_id: question.id, question: { body: nil } }, format: :js }
      it 'does not change question attributes' do
        question.reload
        expect(question.body).to eq question.body
      end
    end
  end
end
