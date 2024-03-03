require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unatheticated can not edit answer'
  describe 'Authenticated user' do
    describe 'author' do
      background do
        sign_in(user)
        visit question_path(question)
        within '.question' do
          click_on 'Edit question'
        end
      end

      scenario 'edits his question', js: true do
        within '.question' do
          fill_in 'Title', with: 'edited title question'
          fill_in 'Body', with: 'edited body question'

          click_on 'Save'

          expect(page).to_not have_content question.title
          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited title question'
          expect(page).to have_content 'edited body question'
          expect(page).to_not have_selector 'textarea'
        end
      end

      scenario 'edits his question with errors'
    end
  end
  scenario "tries to edit other user's answer"
end
