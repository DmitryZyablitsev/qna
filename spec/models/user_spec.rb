require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user) }
  let!(:subscriber) { create(:subscriber, user: user, question: question) }

  it { is_expected.to have_many(:questions).dependent(:destroy) }
  it { is_expected.to have_many(:answers).dependent(:destroy) }
  it { is_expected.to have_many(:rewards).dependent(:destroy) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:authorizations).dependent(:destroy) }
  it { is_expected.to have_many(:subscribers).dependent(:destroy) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }  

  describe '#author_of?' do
    it 'The user is the author question' do
      expect(user.author_of?(question)).to be true
    end

    it 'The user is not the author question' do
      expect(user2.author_of?(question)).to be false
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauth') }

    it 'calls FindForOauth' do
      expect(FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#subscriber?' do
    it 'The user is subscribed to the question' do
      expect(user.subscriber?(question)).to be true
    end
  end
end
