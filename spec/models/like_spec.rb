require 'rails_helper'

RSpec.describe Like do
  let(:existing_like) { create(:like) }

  it { is_expected.to belong_to :likeable }
  it { is_expected.to belong_to :user }

  it { existing_like; is_expected.to validate_uniqueness_of(:user_id).scoped_to(%i[likeable_id likeable_type]) }
end
