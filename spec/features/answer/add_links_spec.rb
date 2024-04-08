require 'rails_helper'

feature 'User can add links to answer', "
In order to provide additional info to my answer
As an answer's author
I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/DmitryZyablitsev/11b2834129c6e9897f680ae4fd6c59d8' }
  given(:school_url) { 'https://thinknetica.com' }

  describe 'User adds links when asks answer', :js do
    background do
      sign_in(user)
      visit question_path(question)

      within '.new-answer' do
        click_on 'Create answer'
        fill_in 'Answer', with: 'My answer'
        fill_in 'Link name', with: 'My gist'
      end
    end

    scenario 'with valid url' do
      within '.new-answer' do
        fill_in 'Url', with: gist_url

        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'My school'
          fill_in 'Url', with: school_url
        end

        click_on 'Create a response'
        visit question_path(question) #### костыль
      end

      within '.answers' do
        expect(page).to have_content 'Hello World'
        expect(page).to have_link 'My school', href: school_url
      end
    end

    scenario 'with invalid url' do
      within '.new-answer' do
        fill_in 'Url', with: 'invalid_url'

        click_on 'Create a response'

        expect(page).to have_content 'Links url is invalid'
      end
    end
  end
end
