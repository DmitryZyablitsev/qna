require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:subscription) { create(:subscriber, user: user, question: question) }


  describe "POST #create" do

    before { login(user) }

    it "saves a new subscriber in the database" do
      expect do
        post :create, params: { subscriber: { question_id: question.id } }
      end.to change(Subscriber, :count).by(1)
    end

    it 'redirect question' do
      post :create, params: { subscriber: { question_id: question.id } }
      expect(response).to redirect_to question
    end

    
    it 'the user has already subscribed to the question' do
      subscription

      expect do
        post :create, params: { subscriber: { question_id: question.id } }
      end.not_to change(Subscriber, :count)
    end

    it 'redirect question' do
      subscription

      post :create, params: { subscriber: { question_id: question.id } }
      expect(response).to redirect_to question
    end
  end

  describe "POST #destroy" do
    before do
      subscription
      login(user)
    end

    it "delete subscriber" do
      expect do
        delete :destroy, params: { id: subscription.id }
      end.to change(Subscriber, :count).by(-1)
    end

    it 'redirect question' do
      delete :destroy, params: { id: subscription.id }
      expect(response).to redirect_to question
    end
  end
end
