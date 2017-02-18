RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question, user: @user) }

  let!(:update_body) do
    Proc.new do |body = 'new body'|
      patch :update_body, params: { id: question, question: { body: body} , format: :js }
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    before do
      update_body.call
    end

    context 'valid attributes' do
      it 'changes question body' do
        question.reload
        expect(question.body.html_safe).to eq 'new body'
      end

      it 'redirects to the updated question view' do
        expect(response).to render_template :update_body
      end
    end

    context 'invalid attributes' do
      before do
        update_body.call(nil)
      end

      it 'does not change question attributes' do
        question.reload
        expect(question.body).to eq question.body
      end
    end
  end
end
