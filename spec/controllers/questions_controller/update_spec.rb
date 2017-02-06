RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'PATCH #update' do
    sign_in_user

    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to the updated question view' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to question
      end
    end

    context 'invalid attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: nil }} }
      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end

      it 'redirects to the edit view' do
        expect(response).to render_template :edit
      end
    end
  end
end
