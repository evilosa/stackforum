RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    sign_in_user
    before { get :show, params: { id: question } }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'build new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end
end
