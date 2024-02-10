require 'rails_helper'

RSpec.describe AnswersController do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        login(user)
        expect do
          post :create,
               params: { question_id: question.id,
                         answer: attributes_for(:answer, question_id: question.id, author_id: user.id) }
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question.id, answer: attributes_for(:answer, :invalid, question_id: question.id) }
        end.not_to change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      question
      answer
    end

    it 'delete the answer' do
      login(user)

      expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to change(Answer, :count).by(-1)
    end

    it 'The non-author cannot delete the answer' do
      login(user2)

      expect { delete :destroy, params: { question_id: question.id, id: answer.id } }.to change(Answer, :count).by(0)
    end
  end
end
