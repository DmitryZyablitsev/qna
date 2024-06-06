require 'rails_helper'

RSpec.describe LikesController do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, author: user2) }
  let!(:like) { create(:like, user: user) }

  describe 'POST #create' do
    context 'the user has the right to like' do
      context 'with valid attributes' do
        it 'saves a new like in the database' do
          login(user)
  
          expect do
            post :create, params: { like: { likeable_id: question.id, likeable_type: question.class.to_s, state: 1 }, format: :html  }
          end.to change(Like, :count).by(1)
        end
      end
    end

    context 'the user does not have the right to like' do
      before { login(user2) }

      it 'does not save the new like in the database' do

        expect do
          post :create, params: { like: { likeable_id: question.id, likeable_type: question.class.to_s, state: 1 }, format: :html   }
        end.to_not change(Like, :count)
      end

      it 'redirect root_path' do
        post :create, params: { like: { likeable_id: question.id, likeable_type: question.class.to_s, state: 1 }, format: :html   }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'The user is the author' do
      it 'delete the like' do
        login(user)

        expect do
          delete :destroy, params: { id: like.id }
        end.to change(Like, :count).by(-1)
      end
    end

    context 'the user is not the author' do
      before { login(user2) }

      it 'not delete the like' do
        expect do
          delete :destroy, params: { id: like.id }
        end.to_not change(Like, :count)
      end

      it 'redirect root_path' do
        delete :destroy, params: { id: like.id }
        expect(response).to redirect_to root_path
      end
    end
  end
end
