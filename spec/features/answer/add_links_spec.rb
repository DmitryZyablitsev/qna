require 'rails_helper'

feature 'User can add links to answer', "
In order to provide additional info to my answer
As an answer's author
I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/DmitryZyablitsev/e07cf54bb8c3eacd8e7be06d7eeeacb0' }

  scenario 'User adds link when asks answer', :js do
    sign_in(user)
    visit question_path(question)

    within '.new-answer' do
      fill_in 'Answer', with: 'My answer'
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Create a response'
    end
    
    within '.other_answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
