require 'rails_helper'

feature 'User can browse certain question', "
  Autheticated and unauthenticated users
  can browse certain question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, author: user, question: question) }
  given!(:answer2) { create(:answer, author: user, question: question) }

  scenario 'Authenticated user browse certain question and answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body
  end

  scenario 'Unauthenticated user browse certain question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer.body
    expect(page).to have_content answer2.body
  end
end
