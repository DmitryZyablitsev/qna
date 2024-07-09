require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to  :user }
  it { should belong_to :question }

  describe 'validations' do
    let(:subscription) { create(:subscription) }   

    it { is_expected.to validate_presence_of :user }
    it { is_expected.to validate_presence_of :question }   
    it { subscription; should validate_uniqueness_of(:question_id).scoped_to([:user_id]) }
  end
end
