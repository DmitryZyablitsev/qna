require 'rails_helper'

RSpec.describe QuestionsController do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:control_question) { question.clone }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns a requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns a new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assigns a new link for answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    context 'User exists' do
      before do
        login(user)
        get :new
      end

      it 'assigns a new Question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assigns a new Link' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'assigns a new Reward' do
        expect(assigns(:question).reward).to be_a_new(Reward)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    context 'User does not exist' do
      it 'redirect root_path' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

  end

  describe 'POST #create' do
    context 'User exists' do
      before { login(user) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          question
          expect do
            post :create, params: { question: { title: question.title, body: question.body, author: question.author } }
          end.to change(Question, :count).by(1)
        end

        it 'redirecrs to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect do
            post :create, params: { question: attributes_for(:question, :invalid) }
          end.not_to change(Question, :count)
        end

        it 're-renders new view' do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end
    end

    context 'User does not exist' do
      it 'redirect new_user_session_path' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do  
  context 'User is the author' do
    before { login(user) }
      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirecrs to updated question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before do
          control_question
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
        end

        it 'does not change question' do
          question.reload

          expect(question.title).to eq control_question.title
          expect(question.body).to eq control_question.body
        end

        it 're-renders edit view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'User is not the author' do
      before do
        login(user2)
        patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
      end

      it 'does not change question' do        
        question.reload

        expect(question.title).to eq control_question.title
        expect(question.body).to eq control_question.body
      end

      it 'redirect question' do
        expect(response).to redirect_to question
      end
    end

  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: user) }

    context 'when user is author' do
      before { login(user) }

      it 'delete the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'User is not the author' do
      before { login(user2) }

      it 'The non-author cannot delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end

      it 'redirect question' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end      
    end
  end
end
