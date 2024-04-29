require 'rails_helper'

feature 'User can add comment to question', "
To provide additional information to the question
The registered user has the opportunity to add a comment
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user creates a comment', :js  do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'successfully' do
      within '.question' do
        fill_in 'comment_body', with: 'My comment'
        click_on 'Add comment'

        expect(page).to have_content 'My comment'
      end
    end

    scenario 'with invalid data' do
      within '.question' do
        click_on 'Add comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user' do
    visit question_path(question)

    within '.question' do
      expect(page).to have_no_content "New comment"
    end
  end

  describe 'mulitple sessions', :js do 
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'comment_body', with: 'My comment'
        click_on 'Add comment'

        expect(page).to have_content 'My comment'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'My comment'
      end
    end
  end
end
