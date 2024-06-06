require 'rails_helper'

RSpec.describe LinksController do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:question) { create(:question, author: user) }
    let!(:link) { create(:link, linkable: question) }

    it 'when user is author delete the link' do
      login(user)

      expect do
        delete :destroy, params: { id: link }, format: :js
      end.to change(Link, :count).by(-1)
    end

    context 'The non-author' do
      before { login(user2) }

      it 'cannot delete the link' do
        expect do
          delete :destroy, params: { id: link }, format: :js
        end.not_to change(Answer, :count)
      end

      it 'redirect @answer.question' do
        delete :destroy, params: { id: link }, format: :js

        expect(response).to redirect_to link.linkable
      end
    end
  end
end
