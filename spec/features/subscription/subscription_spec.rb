require 'rails_helper'

feature 'The user can subscribe to the question', "
  As an authenticated user, I want to be able 
  to subscribe  to a question in order to receive email 
  notifications that someone has answered the selected question
" do
  let(:question) { create(:question) }

  describe 'Authenticated user' do
    let(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'NOT subscribed to the question he wants to subscribe' do
      click_on 'Subscribe'

      expect(page).to have_content 'You subscribed to the question'
      expect(page).to have_button 'Unsubscribe'
    end    

    scenario 'subscribed to the question has the ability to unsubscribe' do
      click_on 'Subscribe'
      click_on 'Unsubscribe'

      expect(page).to have_content 'You have unsubscribed from the question'
      expect(page).to have_button 'Subscribe'
    end
  end

  describe 'User is NOT authenticated' do
    scenario 'does NOT have the opportunity to subscribe' do
      visit question_path(question)

      expect(page).to have_no_button 'Subscribe'
    end
  end
end
