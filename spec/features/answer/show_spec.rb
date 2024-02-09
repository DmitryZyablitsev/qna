require 'rails_helper'

feature 'User can browse list answers certain question', "
  Autheticated and unauthenticated users
  can browse  list answers certain question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, author: user, question: question) }

  scenario 'Authenticated user browse list answers' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content answer.body
  end

  scenario 'Unauthenticated user browse list answers' do
    visit question_path(question)

    expect(page).to have_content answer.body
  end
end
