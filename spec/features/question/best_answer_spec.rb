require 'rails_helper'

feature 'The author of the question can choose the best answer', "
The author of the question can choose the best answer
for his question (the best answer can only be 1)
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user3) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer2) { create(:answer, question: question, author: user2 ) }
  given!(:answer3) { create(:answer, question: question, author: user3 ) }

  scenario 'The author of the question can choose the best answer', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_on 'Best', match: :first

      expect(page).to have_content 'Best Answer'
    end
  end

  scenario 'The non-author of the question cannot choose the best answer', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to have_no_link 'Best'
    end
  end
end
