require 'rails_helper'

feature 'Unregistered user can register' do
  background do
    visit root_path
    click_on 'Register'
  end

  scenario 'User can register with valid data' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User can not register with invalid data' do
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_on 'Sign up'

    expect(page).to have_content 'prohibited this user from being saved:'
  end
end
