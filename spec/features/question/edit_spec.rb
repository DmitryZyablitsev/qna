require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unatheticated can not edit question' do
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated user', js: true do
    describe 'author' do
      background do
        sign_in(user)
        visit question_path(question)
        within '.question' do
          click_on 'Edit question'
        end
      end

      scenario 'edits his question' do
        within '.question' do
          fill_in 'Title', with: 'edited title question'
          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to have_content 'edited title question'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his question with errors' do 
        fill_in 'Title', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
      end

    end
  end

  scenario "tries to edit other user's question" do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_link 'Edit question'
  end
end