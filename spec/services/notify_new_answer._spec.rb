require 'rails_helper'

RSpec.describe NotifyNewAnswer do
  let(:users) { create_list(:user, 3) }

  it 'sends notify new answer to subscribers' do
    users.each { |user| expect(NotifyNewAnswerMailer).to receive(:notify).with(user).and_call_original }
    subject.send_notify
  end
end
