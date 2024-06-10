require 'rails_helper'

feature 'The author can delete his question', "
The author can delete his own question,
but cannot delete someone else's question
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:user_admin) { create(:user, admin: true) }
  given!(:question) { create(:question, author: user) }

  scenario 'The author can delete the question' do
    sign_in(user)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
  end

  scenario 'Admin can delete the question' do
    sign_in(user_admin)
    visit question_path(question)

    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(page).to have_no_content question.title
    expect(page).to have_no_content question.body
  end

  scenario "Authenticated user cannot delete someone else's question" do
    sign_in(user2)
    visit question_path(question)

    expect(page).to have_no_button 'Delete question'
  end

  scenario 'Unauthenticated user cannot delete question' do
    visit question_path(question)

    expect(page).to have_no_button 'Delete question'
  end
end
