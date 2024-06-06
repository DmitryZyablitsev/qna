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
                         answer: attributes_for(:answer, question_id: question.id, author_id: user.id) }, format: :json
        end.to change(Answer, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               params: { question_id: question.id,
                         answer: attributes_for(:answer, :invalid, question_id: question.id) }, format: :js
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

      expect do
        delete :destroy, params: { question_id: question.id, id: answer.id }, format: :js
      end.to change(Answer, :count).by(-1)
    end

    context 'The non-author' do
      before { login(user2) }

      it 'cannot delete the answer' do
        expect do
          delete :destroy, params: { question_id: question.id, id: answer.id }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'redirect @answer.question' do
        delete :destroy, params: { question_id: question.id, id: answer.id }, format: :js

        expect(response).to redirect_to question
      end
    end
  end

  describe 'PATCH #update' do
    context 'The user is the author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer.id, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.not_to change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'The user is not the author' do
      before { login(user2) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        end.not_to change(answer, :body)
      end

      it 'redirect_to answer.question' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to  redirect_to answer.question
      end
    end
  end

  describe 'PATCH #best' do
    context 'The user is the author of the question' do
      before { login(user) }

      it 'changes answer attribute best' do
        patch :best, params: { id: answer.id }, format: :js
        question.reload

        expect(question.best_answer_id).to eq answer.id
      end

      it 'renders update view' do
        patch :best, params: { id: answer.id }, format: :js
        expect(response).to render_template :best
      end
    end

    context 'The user is not the author of the question' do
      before { login(user2) }

      it 'changes answer attribute best' do
        patch :best, params: { id: answer.id }, format: :js
        question.reload

        expect(question.best_answer_id).to_not eq answer.id
      end

      it 'redirest answer.question' do
        patch :best, params: { id: answer.id }, format: :js
        expect(response).to redirect_to answer.question
      end
    end
  end
end
