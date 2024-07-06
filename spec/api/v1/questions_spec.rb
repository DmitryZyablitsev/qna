require 'rails_helper'

describe 'Questions API', type: :request do
  let!(:headers) { { "ACCEPT" => 'application/json' } }
  let(:user)  { create(:user)}
  let(:access_token) {create(:access_token, resource_owner_id: user.id )}
  let(:question) { create(:question) }  

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Returns list of objects' do
        let(:given_response) { json['questions'] }
        let(:count) { questions.size }
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json # я не понял как здесь примемить math
        end        
      end

      it 'contains user object' do
        expect(question_response['author']['id']).to eq question.author.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body author_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end        
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let!(:link) {links.first }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: question.author) }
    let!(:comment) { comments.first }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:question_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json["question"][attr]).to eq question.send(attr).as_json
        end
      end

      describe 'links' do
        let(:links_response) { json['question']['links'] }       

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { links_response }
          let(:count) { question.links.size }
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(json['question']['links'].first[attr]).to eq link.send(attr).as_json
          end
        end
      end


      describe 'comments' do
        let(:comments_response) { json['question']['comments'] }

        it_behaves_like 'Returns list of objects' do
          let(:given_response) { comments_response }
          let(:count) { question.comments.size }
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comments_response.first[attr]).to eq comment.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorazed' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Successful response'

      it_behaves_like 'Returns list of objects' do
        let(:given_response) { json['answers'] }
        let(:count) { 3 }
      end

      it 'returns all public fields' do
        %w[id body author_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do

      context 'valid' do
        before do 
          post api_path, params: { action: :create, format: :json, access_token: access_token.token, question: { title: 'test', body: 'test'}}
        end

        it_behaves_like 'Successful response'

        it 'contains user object with question attrs' do
          expect(json['question']['body']).to eq 'test'
          expect(json['question']['title']).to eq 'test'
          expect(json['question']['author_id']).to eq access_token.resource_owner_id
        end
      end

      context 'invalid' do
        before do
          post api_path, params: { action: :create, format: :json, access_token: access_token.token, question: { title: '', body: ''}}
        end

        it 'returns 422 status and errors' do
          expect(response.status).to eq 422
          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:user) { create(:user)}
    let!(:question) { create(:question, author: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token, resource_owner_id: user.id )}

      context 'with valid attributes' do
        before do
          patch api_path, params: { action: :update, format: :json, access_token: access_token.token, question: { title: 'update-test', body: 'update-body'}}
        end

        it_behaves_like 'Successful response'

        it 'contains user object with json attr' do
          expect(json['question']['title']).to eq 'update-test'
          expect(json['question']['body']).to eq 'update-body'
          expect(json['question']['author_id']).to eq question.author.id
        end
      end


      context 'with invalid attributes' do
        before do
          patch api_path, params: {question: { title: '', body: '' }, access_token: access_token.token }, headers: headers
        end

        it 'returns 422 status and errors' do
          expect(response.status).to eq 422
          expect(json['errors']).to be
        end
      end

      context 'User is not the author' do
        let!(:another_user)  { create(:user)}
        let(:access_token) {create(:access_token, resource_owner_id: another_user.id )}
        let!(:question_control) {question.clone}

        before do
          patch api_path, params: { action: :update, format: :json, access_token: access_token.token, question: { title: 'no-update-test', body: 'no-update-body'}}
        end

        it 'does not update a question' do
          question.reload

          expect(question.title).to eq question_control.title
          expect(question.body).to eq question_control.body
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:user)       { create(:user)}
    let!(:question)   { create(:question, author: user) }
    let!(:api_path)   { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized author' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'deletes the question' do
        expect do
          delete api_path, params: { access_token: access_token.token}, headers: headers
        end.to change(Question, :count).by(-1)
      end

      it 'returns 200 status' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        expect(response).to be_successful
      end

      it 'returns deleted question json' do
        delete api_path, params: { access_token: access_token.token}, headers: headers
        %w[id title body author_id created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq question.send(attr).as_json
        end
      end
    end

    context 'authorized with wrong access token' do
      it 'does non deletes the question' do
        expect do
          delete api_path, params: { access_token: '1234'}, headers: headers
        end.to_not change(Question, :count)
      end
    end
  end
end
