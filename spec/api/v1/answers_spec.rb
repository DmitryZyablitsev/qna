require 'rails_helper'

describe 'Profile API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { '/api/v1/answers/:id' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end
  end

  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let(:answer) { create(:answer) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let!(:link) {links.first }
    let!(:comments) { create_list(:comment, 2, commentable: answer, user: answer.author) }
    let!(:comment) { comments.first }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it_behaves_like 'Successful response'

    it 'returns all public fields' do
      %w[id body comments links created_at updated_at].each do |attr|
        expect(json["answer"][attr]).to eq answer.send(attr).as_json
      end
    end

    describe 'links' do
      let(:links_response) { json['answer']['links'] }

      it_behaves_like 'Returns list of objects' do
        let(:given_response) { links_response }
        let(:count) { answer.links.size }
      end

      it 'returns all public fields' do
        %w[id name url created_at updated_at].each do |attr|
          expect(links_response.first[attr]).to eq link.send(attr).as_json
        end
      end
    end

    describe 'comments' do
      let(:comments_response) { json['answer']['comments'] }

      it_behaves_like 'Returns list of objects' do
        let(:given_response) { comments_response }
        let(:count) { answer.comments.size }
      end

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(comments_response.first[attr]).to eq comment.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions/question_id/answers' do
    let!(:user) { create(:user)}
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token, resource_owner_id: user.id )}

      context 'with valid attributes' do

        before do
          post api_path, params: { action: :create, format: :json, access_token: access_token.token, answer: { body: 'body', question: question, author: user }}
        end

        it_behaves_like 'Successful response'

        it 'contains user object with answer attr' do
          expect(json['answer']['body']).to eq 'body'
          expect(json['answer']['author_id']).to eq access_token.resource_owner_id
        end
      end
    

      context 'with invalid attributes' do
        before do 
          post api_path, params: { action: :create, format: :json, access_token: access_token.token, answer: { body: '', question: question, author: user }}
        end

        it 'returns 422 status and errors' do
          expect(response.status).to eq 422
          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token, resource_owner_id: user.id )}

      context 'with valid attributes' do
        before do
          patch api_path, params: { action: :update, format: :json, access_token: access_token.token, answer: { body: 'update-body'}}
        end

        it_behaves_like 'Successful response'
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: { action: :update, format: :json, access_token: access_token.token, answer: { body: ''}}
        end

        it 'returns 422 status and errors' do
          expect(response.status).to eq 422
          expect(json['errors']).to be
        end
      end

      context 'User is not the author' do
        let!(:another_user)  { create(:user)}
        let(:access_token) {create(:access_token, resource_owner_id: another_user.id )}
        let!(:answer_control) {answer.clone}

        before do
          patch api_path, params: { action: :update, format: :json, access_token: access_token.token, answer: { body: 'update-body'}}
        end

        it 'does not update a answer' do
          answer.reload

          expect(answer.body).to eq answer_control.body
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:answer) { create(:answer, question: question, author: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'deletes the answer' do
        expect do
          delete api_path, params: { access_token: access_token.token}, headers: headers
        end.to change(Answer, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        expect(response).to be_successful
      end      
    end

    context 'authorized with wrong access token' do
      it 'does non deletes the answer' do
        expect do
          delete api_path, params: { access_token: '1234'}, headers: headers
        end.to_not change(Answer, :count)
      end
    end
  end
end
