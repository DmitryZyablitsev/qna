require 'rails_helper'

feature 'User can like for the question', "
  To point out a useful question
  As an authenticated user
  I would like to be able to like another question.
" do # , :js do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user2) }

  describe 'Authenticated user' do
    scenario "can like someone else's question" do
      sign_in(user)
      visit question_path(question)

      click_on 'Like'

      expect(page).to have_content '1'
    end

    scenario "can't like my question" do
      sign_in(user2)
      visit question_path(question)

      within '.question' do
        expect(page).to have_no_button('Like')
      end
    end
  end

  scenario "Unauthenticated user can't vote for a question"
end
