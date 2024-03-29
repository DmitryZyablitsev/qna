require 'rails_helper'

feature 'The user can create an answer to the question', "
An authenticated user, while on the question page, can create
an answer to the question.
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'can write an answer', :js do
      fill_in 'Answer', with: answer.body
      click_on 'Create a response'

      expect(page).to have_content answer.body
    end

    scenario 'can write an answer with attached file', :js do
      fill_in 'Answer', with: answer.body
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create a response'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answer with errors', :js do
      fill_in 'Answer', with: ''
      click_on 'Create a response'

      expect(page).to have_content 'error(s) detected:'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user can not write an answer' do
    visit question_path(question)
    click_on 'Create a response'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
