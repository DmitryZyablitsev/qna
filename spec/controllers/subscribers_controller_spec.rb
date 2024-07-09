require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:subscription) { create(:subscription, user: user, question: question) }


  describe "POST #create" do

    before { login(user) }

    it "saves a new subscription in the database" do
      expect do
        post :create, params: { subscription: { question_id: question.id } }
      end.to change(Subscription, :count).by(1)
    end

    it 'redirects question' do
      post :create, params: { subscription: { question_id: question.id } }
      expect(response).to redirect_to question
    end

    
    it 'the user is subscribed to the question' do
      subscription

      expect do
        post :create, params: { subscription: { question_id: question.id } }
      end.not_to change(Subscription, :count)
    end

    it 'redirects question' do
      subscription

      post :create, params: { subscription: { question_id: question.id } }
      expect(response).to redirect_to question
    end
  end

  describe "POST #destroy" do
    before do
      subscription
      login(user)
    end

    it "deletes subscription" do
      expect do
        delete :destroy, params: { id: subscription.id }
      end.to change(Subscription, :count).by(-1)
    end

    it 'redirects question' do
      delete :destroy, params: { id: subscription.id }
      expect(response).to redirect_to question
    end
  end
end
