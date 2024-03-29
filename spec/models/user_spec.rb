require 'rails_helper'

RSpec.describe User do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:question) { create(:question, author: user) }

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :password }

  it 'The user is the author question' do
    expect(user.author_of?(question)).to be true
  end

  it 'The user is not the author question' do
    expect(user2.author_of?(question)).to be false
  end
end
