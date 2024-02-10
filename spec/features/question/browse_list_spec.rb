require 'rails_helper'

feature 'User can browse list questions', "
  Autheticated and unauthenticated users
  can browse list questions
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question2) { create(:question) }

  scenario 'Authenticated user browse list questions' do
    sign_in(user)

    visit questions_path

    expect(page).to have_content 'All questions'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question2.title
  end

  scenario 'Unauthenticated user browse list questions' do
    visit questions_path

    expect(page).to have_content 'All questions'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content question2.title
  end
end
