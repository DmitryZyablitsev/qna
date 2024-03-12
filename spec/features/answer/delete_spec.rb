require 'rails_helper'

feature 'The author can delete his answer', "
The author can delete his own answer,
but cannot delete someone else's answer
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'The author can delete the answer', :js do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete answer'

    expect(page).to have_no_content answer.body
  end

  scenario "Authenticated user cannot delete someone else's answer", :js do
    sign_in(user2)
    visit question_path(question)

    expect(page).to have_no_button 'Delete question'
  end

  scenario 'Unauthenticated user cannot delete answer', :js do
    visit question_path(question)

    expect(page).to have_no_button 'Delete answer'
  end
end
