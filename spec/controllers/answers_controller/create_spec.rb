RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer_valid_params) { {answer: attributes_for(:answer), question_id: question} }
  let!(:answer_invalid_params) { {answer: attributes_for(:answer, :invalid), question_id: question} }

  let!(:create_post) do
    Proc.new do |params = answer_valid_params |
      post :create, params: params
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'save new answer for the question in the database' do
        expect { create_post.call }.to change(question.answers, :count).by(1)
      end

      it 'redirect to question show view' do
        create_post.call
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer for question in the database' do
        expect { create_post.call(answer_invalid_params) }.to_not change(question.answers, :count)
      end

      it 're-render answer new view' do
        create_post.call(answer_invalid_params)
        expect(response).to render_template :new
      end
    end
  end
end