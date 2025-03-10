require 'rails_helper'

RSpec.describe Answer do
  it { is_expected.to have_many(:links).dependent(:destroy) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }


  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_length_of(:body).is_at_least(3).on(:create) }

  it { is_expected.to accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'send_email' do
    let(:answer) { build(:answer) }

    it 'calls NotifyNewAnswerJob' do
      expect(NotifyNewAnswerJob).to receive(:perform_later).with(answer)
      answer.save!
    end

    it 'no calls NotifyNewAnswerJob when updating' do
      expect(NotifyNewAnswerJob).to receive(:perform_later).with(answer)
      answer.update!(body: 'body')
    end
  end
end
