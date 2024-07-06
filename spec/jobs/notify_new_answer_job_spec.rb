require 'rails_helper'

RSpec.describe NotifyNewAnswerJob, type: :job do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question) }
  let!(:subscriber) { create(:subscriber, question: question, user: user) }

  it 'inform only author and subscribers for new answer' do
    expect(NewAnswerMailer).to receive(:inform).with(answer, user).and_call_original
    expect(NewAnswerMailer).to_not receive(:inform).with(answer, answer.author).and_call_original

    NotifyNewAnswerJob.perform_now(answer)
  end
end
