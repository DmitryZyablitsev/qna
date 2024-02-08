require 'rails_helper'

feature 'An authenticated user can log out of the system' do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'user logs out of the system' do
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
