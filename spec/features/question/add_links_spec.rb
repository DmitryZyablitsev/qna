require 'rails_helper'

feature 'User can add links to question', "
In order to provide additional info to my question
As an question's author
I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/DmitryZyablitsev/11b2834129c6e9897f680ae4fd6c59d8' }
  given(:school_url) { 'https://thinknetica.com' }

  describe 'User adds links when asks question', :js do

    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My link'
    end

    scenario 'with valid url' do
      fill_in 'Url', with: gist_url
      click_on 'add link'

      within all('.nested-fields').last do
        fill_in 'Link name', with: 'My school'
        fill_in 'Url', with: school_url
      end

      click_on 'Ask'

      expect(page).to have_content 'Hello World'
      expect(page).to have_link 'My school', href: school_url
    end

    scenario 'with invalid url' do      
      fill_in 'Url', with: 'invalid_url'
      click_on 'Ask'

      expect(page).to have_content 'Links url is invalid'
    end
  end

  describe 'Author adds links when edit question', :js do
    background do
      sign_in(user)
      visit new_question_path

      click_on 'Edit question'
      click_on 'add link'
    end

    scenario 'with valid url' do
      within '.question' do
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: school_url
        click_on 'add link'
        within '.nested-fields' do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url
        end
        click_on 'Save'
        within '.links' do
          expect(page).to have_link 'My link', href: school_url
          expect(page).to have_content 'Hello World'
        end
      end      
    end

    scenario 'with invalid url'

  end
end
