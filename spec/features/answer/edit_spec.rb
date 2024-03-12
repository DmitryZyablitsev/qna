require 'rails_helper'

feature 'User can edit his answer', "
In order to correct mistakes
As an author of answer
I'd like ot be able to edit my answer
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unatheticated can not edit answer' do
    visit question_path(question)

    expect(page).to have_no_link 'Edit'
  end

  describe 'Authenticated user' do
    describe 'author' do
      background do
        sign_in(user)
        visit question_path(question)
        click_on 'Edit'
      end

      scenario 'edits his answer', :js do
        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'

          click_on 'Save'

          expect(page).to have_no_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to have_no_css 'textarea'
        end
      end

      scenario 'edits his answer with errors', :js do
        within '.answers' do
          fill_in 'Your answer', with: '1A'
          click_on 'Save'

          expect(page).to have_content answer.body
          expect(page).to have_css 'textarea'
        end
        expect(page).to have_content 'Body is too short (minimum is 3 characters)'
      end
    end

    scenario "tries to edit other user's answer" do
      sign_in(user2)
      visit question_path(question)

      expect(page).to have_no_link 'Edit'
    end
  end
end
