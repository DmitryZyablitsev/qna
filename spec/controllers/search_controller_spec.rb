require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do

    it 'global search' do
      expect(ThinkingSphinx).to receive(:search).with 'test'
      get :search, params: {'query' => 'test', 'area' => 'Global', 'commit' => 'Search'} 
    end

    ["Question", "Answer", "Comment", "User" ].each do |scope|
      it "search in scopes" do
        expect(scope.constantize).to receive(:search).with 'test'
        get :search, params: {'query' => 'test', 'area' => scope, 'commit' => 'Search'}
      end
    end

    it 'params invalid, assigns [] to @search_result' do
      get :search, params: {'query' => 'test', 'area' => 'invalid', 'commit' => 'Search'}
      expect(assigns(:search_result)).to eq []
    end
  end
end
