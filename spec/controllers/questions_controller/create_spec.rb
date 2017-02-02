RSpec.describe QuestionsController, type: :controller do
  let!(:question_valid_params) { {question: attributes_for(:question)} }
  let!(:question_invalid_params) { {question: attributes_for(:question, :invalid)} }

  let!(:create_post) do
    Proc.new do |params = question_valid_params |
      post :create, params: params
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { create_post.call }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        create_post.call
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new question in the database' do
        expect { create_post.call(question_invalid_params) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        create_post.call(question_invalid_params)
        expect(response).to render_template :new
      end
    end
  end
end
