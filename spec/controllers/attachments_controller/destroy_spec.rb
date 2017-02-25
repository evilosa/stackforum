RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    sign_in_user

    context 'author delete his attachment' do

      context 'for question' do
        let!(:question) { create(:question, user: @user) }
        let!(:question_attachment) { create(:attachment, attachable: question) }

        it 'delete question''s attachment' do
          expect { delete :destroy, params: { id: question_attachment, format: :js }}.to change(question.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: { id: question_attachment, format: :js }
          expect(response).to render_template :destroy
        end
      end

      context 'for answer' do
        let!(:answer) { create(:answer, user: @user) }
        let!(:answer_attachment) { create(:attachment, attachable: answer) }

        it 'delete answer''s attachment' do
          expect { delete :destroy, params: { id: answer_attachment, format: :js }}.to change(answer.attachments, :count).by(-1)
        end

        it 'render template' do
          delete :destroy, params: { id: answer_attachment, format: :js }
          expect(response).to render_template :destroy
        end
      end

    end

    context 'not author tries to delete the attachment' do
      let!(:second_user) { create(:user) }

      context 'for question' do
        let!(:question) { create(:question, user: second_user) }
        let!(:question_attachment) { create(:attachment, attachable: question) }

        it 'try to delete question''s attachment' do
          expect { delete :destroy, params: { id: question_attachment, format: :js }}.not_to change(question.attachments, :count)
        end
      end

      context 'for answer' do
        let!(:answer) { create(:answer, user: second_user) }
        let!(:answer_attachment) { create(:attachment, attachable: answer) }

        it 'try to delete answer''s attachment' do
          expect { delete :destroy, params: { id: answer_attachment, format: :js }}.not_to change(answer.attachments, :count)
        end
      end
    end
  end
end