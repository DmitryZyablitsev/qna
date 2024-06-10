require 'rails_helper'

feature 'The user can create an answer to the question', "
An authenticated user, while on the question page, can create
an answer to the question.
" do
  given(:user) { create(:user) }
  given(:admin) { create(:user, admin: true) }  
  given(:question) { create(:question) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
      click_on 'Create answer'
    end

    scenario 'can write an answer', :js do
      within '.new-answer' do
        fill_in 'Answer', with: answer.body
        click_on 'Create a response'
      end
      
      within '.other_answers' do
        expect(page).to have_content answer.body
      end
    end

    scenario 'can write an answer with attached file' do
      within '.new-answer' do
        fill_in 'Answer', with: answer.body
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create a response'
      end

      within '.other_answers' do
        expect(page).to have_content answer.body
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
      
    end

    scenario 'answer with errors', :js do
      fill_in 'Answer', with: ''
      click_on 'Create a response'

      expect(page).to have_content 'error(s) detected:'
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Admin' do
    background do
      sign_in(admin)

      visit question_path(question)
      click_on 'Create answer'
    end

    scenario 'can write an answer', :js do
      within '.new-answer' do
        fill_in 'Answer', with: answer.body
        click_on 'Create a response'
      end
      
      within '.other_answers' do
        expect(page).to have_content answer.body
      end
    end

    scenario 'can write an answer with attached file' do
      within '.new-answer' do
        fill_in 'Answer', with: answer.body
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create a response'
      end

      within '.other_answers' do
        expect(page).to have_content answer.body
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
      
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

  describe 'mulitple sessions', :js do 
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        click_on 'Create answer'
        fill_in 'Answer', with: 'Test answer'
        click_on 'Create a response'



        expect(page).to have_content 'Test answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Test answer'
      end
    end
  end
end
