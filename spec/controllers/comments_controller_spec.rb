require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:comment) { create(:comment, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new comment in the database' do
        login(user)

        expect do
          post :create, params: { comment: { commentable_id: question.id, commentable_type: question.class.to_s } }
        end.to change(Comment, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save a new comment in the database' do
        expect do
          post :create, params: { comment: { commentable_id: '', commentable_type: '' }, format: :json }
        end.not_to change(Comment, :count)
      end        
    end
  end
end
