require 'rails_helper'

feature 'User can add comment to answer', "
To provide additional information to the answer
The registered user has the opportunity to add a comment
" do
  given!(:user) { create(:user) }
  given!(:admin) { create(:user, admin: true) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user creates a comment', :js  do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'successfully' do
      within "#answer-#{answer.id}" do
        fill_in 'comment_body', with: 'My comment'
        click_on 'Add comment'

        expect(page).to have_content 'My comment'
      end
    end

    scenario 'with invalid data' do
      within '.other_answers' do
        click_on 'Add comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'An unverified user cannot create a comment', :js  do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to have_no_button 'Add comment'
    end
  end

  describe 'Admin creates a comment', :js  do
    background do
      sign_in(admin)
      visit question_path(question)
    end

    scenario 'successfully' do
      within "#answer-#{answer.id}" do
        fill_in 'comment_body', with: 'My comment'
        click_on 'Add comment'

        expect(page).to have_content 'My comment'
      end
    end

    scenario 'with invalid data' do
      within '.other_answers' do
        click_on 'Add comment'
        expect(page).to have_content "Body can't be blank"
      end
    end
  end
end
