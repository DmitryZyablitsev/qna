require 'sphinx_helper'

feature 'User can search the site', "
  To find the information you need 
  As a user
  I would like to be able to search the site
" do
  describe 'User searches in the category' do
    let!(:question) { create(:question, body: 'text-question') }
    let!(:answer) { create(:answer, body: 'text-answer') }
    let!(:comment_q) { create(:comment, body: 'text-coment-question', commentable: question ) }
    let!(:comment_a) { create(:comment, body: 'text-coment-answer', commentable: answer) }
    let!(:user) { create(:user, email: 'user@mail.ru') }

    background do 
      ThinkingSphinx::Test.index
      visit root_path
    end

    scenario 'question', sphinx: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in 'query', with: 'text-question'
          select 'Question', from: 'area' 
          click_on 'Search'
        end

        expect(page).to have_content 'Search results:'
        expect(page).to have_content 'Question:'
        expect(page).to have_content 'text-question'
        expect(page).to have_link question.title
      end
    end

    scenario 'answer', sphinx: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in 'query', with: 'text-answer'
          select 'Answer', from: 'area' 
          click_on 'Search'
        end
        
        expect(page).to have_content 'Search results:'
        expect(page).to have_content 'Answer:'
        expect(page).to have_content 'text-answer'
        expect(page).to have_link answer.question.title
      end
    end

    scenario 'comment-question', sphinx: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in 'query', with: 'text-coment-question'
          select 'Comment', from: 'area' 
          click_on 'Search'
        end

        expect(page).to have_content 'Search results:'
        expect(page).to have_content 'Comment:'
        expect(page).to have_content 'text-coment-question'
        expect(page).to have_link comment_q.commentable.title
      end
    end

    scenario 'comment-answer', sphinx: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in 'query', with: 'text-coment-answer'
          select 'Comment', from: 'area' 
          click_on 'Search'
        end

        expect(page).to have_content 'Search results:'
        expect(page).to have_content 'Comment:'
        expect(page).to have_content 'text-coment-answer'
        expect(page).to have_link comment_a.commentable.body
      end
    end

    scenario 'user', sphinx: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in 'query', with: 'user'
          select 'User', from: 'area' 
          click_on 'Search'
        end

        expect(page).to have_content 'Search results:'
        expect(page).to have_content 'User:'
        expect(page).to have_content 'user@mail.ru'
      end
    end

    scenario 'global', sphinx: true do
      ThinkingSphinx::Test.run do
        within '.search' do
          fill_in 'query', with: 'text'
          select 'Global', from: 'area' 
          click_on 'Search'
        end

        expect(page).to have_content 'Search results:'
        expect(page).to have_content 'Question:'
        expect(page).to have_content 'Answer:'
        expect(page).to have_content 'Comment:'
      end
    end
  end
end
