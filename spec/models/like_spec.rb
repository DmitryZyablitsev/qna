require 'rails_helper'

RSpec.describe Like do
  let(:user) { create(:user) }
  let!(:existing_like) { create(:like, user: user) }
  it { is_expected.to belong_to :likeable }
  it { is_expected.to belong_to :user }

  it { should validate_uniqueness_of(:user_id).scoped_to([:likeable_id, :likeable_type]) }
end
