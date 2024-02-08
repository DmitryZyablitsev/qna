require 'rails_helper'

feature 'User can browse certain question', "
  Autheticated and unauthenticated users
  can browse certain question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user browse certain question' do
    sign_in(user)

    visit "#{questions_path}/#{question.id}"

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'Unauthenticated user browse certain question' do
    visit "#{questions_path}/#{question.id}"

    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end
end
