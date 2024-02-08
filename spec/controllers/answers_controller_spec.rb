require 'rails_helper'

RSpec.describe AnswersController do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        login(user)
        expect do
          post :create, params: { question_id: question.id, answer: attributes_for(:answer, question_id: question.id) }
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
end
