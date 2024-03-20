require 'rails_helper'

feature 'User can see list of achieved rewards', "
  In order to see my achievements
  As user
  I'd like to be able to see list of my rewards
" do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given!(:reward) { create(:reward, user: user, question: question)}
  
  describe 'Authenticated user' do
    scenario 'who has rewards' do
      sign_in(user)

      click_on 'My rewards'
      user.rewards.each do |reward|
        expect(page).to have_content reward.name
        expect(page).to have_content reward.question.title
        expect(page).to have_selector '.reward-image'
      end
    end

    scenario 'who has not rewards' do
      sign_in(user2)

      expect(page).to_not have_link 'My rewards'
    end
  end

  scenario 'Unauthenticated user' do
    visit root_path
    expect(page).to_not have_link 'My rewards'
  end
end
