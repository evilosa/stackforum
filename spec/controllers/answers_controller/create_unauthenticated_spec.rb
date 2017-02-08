RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let!(:answer_valid_params) { {answer: attributes_for(:answer), question_id: question} }
  let!(:answer_invalid_params) { {answer: attributes_for(:answer, :invalid), question_id: question} }

  let!(:create_post) do
    Proc.new do |params = answer_valid_params |
      post :create, params: params
    end
  end

  describe 'POST #create unauthenticated' do
    context 'with valid attributes' do
      it 'not save new answer for the question in the database' do
        expect { create_post.call }.to_not change(question.answers, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer for question in the database' do
        expect { create_post.call(answer_invalid_params) }.to_not change(question.answers, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end