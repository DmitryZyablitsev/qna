require 'rails_helper'

RSpec.describe LikesController do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, author: user2) }
  let!(:like) { create(:like, user: user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new like in the database' do
        login(user)

        expect do
          post :create, params: { like: { likeable_id: question.id, likeable_type: question.class.to_s } }
        end.to change(Like, :count).by(1)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'delete the like' do
      login(user)

      expect do
        delete :destroy, params: { id: like.id }
      end.to change(Like, :count).by(-1)
    end
  end
end
