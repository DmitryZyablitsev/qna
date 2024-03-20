require 'rails_helper'

feature 'The author can delete his link', "
The author can delete his own link
but cannot delete someone else's link
" do
  given!(:user) { create(:user) }
  given(:school_url) { 'https://thinknetica.com' }

  scenario 'Author of link delete it', :js do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Ruby'
    fill_in 'Body', with: 'Code'

    fill_in 'Link name', with: 'My school'
    fill_in 'Url', with: school_url

    click_on 'Ask'
    click_on 'Delete link'

    expect(page).to_not have_content 'My school'
  end
end
