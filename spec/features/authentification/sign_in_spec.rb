require 'rails_helper'

feature 'A registered user can log in to the system' do
  given(:user) { create(:user) }

  background { visit new_user_session_path }

  scenario 'user is in the system' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'user is not in the system' do
    fill_in 'Email', with: 'wrong_email'
    fill_in 'Password', with: 'wrong_password'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
