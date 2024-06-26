require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to :commentable }
  it { is_expected.to belong_to :user }

  it { is_expected.to validate_presence_of :body }
  it { should validate_length_of(:body).is_at_most(100) }
end
