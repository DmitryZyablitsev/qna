require 'rails_helper'

feature 'The author can delete attached file his question', "
The author can delete his attached file from the question,
but I can't delete someone else's file
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Author can delete his attached file', :js do
    sign_in(user)

    visit question_path(question)
    click_on'Edit question'

    within '.question' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'

      click_on 'Delete file'
 
      expect(page).to have_no_link 'rails_helper.rb'
    end
  end

  scenario "a non-author cannot delete someone else's attached file", :js do
    sign_in(user2)
    visit question_path(question)

    expect(page).to have_no_link 'rails_helper.rb'
  end

end
