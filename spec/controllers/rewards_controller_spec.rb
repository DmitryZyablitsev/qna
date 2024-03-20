require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:rewards) { create_list(:reward, 5) }

  describe "GET #index" do
    it "populates an array of all rewards" do
      login(user)
      get :index

      expect(assigns(:rewards)).to match_array(user.rewards)
    end
  end
end
