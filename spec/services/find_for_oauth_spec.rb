require 'rails_helper'

RSpec.describe FindForOauth do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
  describe '#call' do
    subject { FindForOauth.new(auth).call }
    
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')

        expect(subject).to eq user
      end
    end

    context 'user has not authorization' do
      context 'provider did not return the email' do
        it 'return nil' do
          expect(subject).to eq nil
        end
      end

      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { subject }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { subject }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = subject.authorizations.first

          expect(authorization.provider).to eq auth.provider         
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(subject).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { subject.to change(User, :count).by(1) }
        end

        it 'returns new user' do
          expect(subject).to be_a(User)
        end

        it 'fills user email' do
          user = subject
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = subject
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = subject.authorizations.first

          expect(authorization.provider).to eq auth.provider         
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
