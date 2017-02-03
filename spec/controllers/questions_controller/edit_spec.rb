RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end
end
