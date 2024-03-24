require 'rails_helper'

RSpec.describe Answer do
  it { is_expected.to have_many(:links).dependent(:destroy) }

  it { is_expected.to belong_to(:question) }
  it { is_expected.to belong_to(:author) }

  it { is_expected.to validate_presence_of :body }

  it { is_expected.to validate_length_of(:body).is_at_least(3).on(:create) }

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
