require 'rails_helper'

feature 'The author can delete attached file his question', "
The author can delete his attached file from the question,
but I can't delete someone else's file
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Author can delete his attached file' do
    sign_in(user)

    visit question_path(question)
    within '.question' do
      click_on 'Delete file'

      # expect(page).to have_no_content 
    end
  end

  scenario "a non-author cannot delete someone else's attached file"
end
