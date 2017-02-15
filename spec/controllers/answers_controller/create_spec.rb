RSpec.describe AnswersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer_valid_params) { {answer: attributes_for(:answer), question_id: question} }
  let!(:answer_invalid_params) { {answer: attributes_for(:answer, :invalid), question_id: question} }

  let!(:create_post) do
    Proc.new do |params = answer_valid_params |
      post :create, params: params, format: :js
    end
  end

  describe 'POST #create authenticated' do
    before do
      login_as(user, scope: :user)
    end

    context 'with valid attributes' do
      it 'save new answer for the question in the database' do
        question.reload
        expect { create_post.call }.to change(question.answers, :count).by(1)
      end

      it 'render answer create template' do
        create_post.call
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer for question in the database' do
        expect { create_post.call(answer_invalid_params) }.to_not change(question.answers, :count)
      end

      it 'render answer create template' do
        create_post.call(answer_invalid_params)
        expect(response).to render_template :create
      end
    end
  end
end