require 'rails_helper'

feature 'User can sign in with vkontakte', "
  as User
  I'd like to be able to sign in  with vkontakte
" do
  describe 'User signs in with Vkontakte' do
    given!(:user) { create(:user) }
    background { visit new_user_session_path }

    describe 'login with vkontakte' do
      scenario 'existing user' do
        mock_auth :vkontakte, email: user.email
        click_on 'Sign in with Vkontakte'

        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end
    end
  end
end
