require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create :question, author_id: user.id }
    let(:othe_question) { create :question, author_id: other_user.id }
    let(:answer) { create :answer, author_id: user.id }    

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    
    # Question
    it { should be_able_to :create, Question }
    it { should be_able_to :update, question }
    it { should_not be_able_to :update, create(:question, author: other_user) }
    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, create(:question, author: other_user) }

    # Answer
    it { should be_able_to :create, Answer }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, create(:answer, author: other_user) }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, create(:answer, author: other_user) }
    it { should be_able_to :best, create(:answer, question: question, author: user) }

    # Comment
    it { should be_able_to :create, Comment }

    # Like
      # Question
    it { should_not be_able_to(:manage, create(:like, likeable: question, user_id: user.id)) }
    it { should be_able_to(:manage, create(:like, likeable: question, user_id: other_user.id)) }
      # Answer
    it { should_not be_able_to(:manage, create(:like, likeable: question, user_id: user.id)) }
    it { should be_able_to(:manage, create(:like, likeable: question, user_id: other_user.id)) }

    # Link
    it { should be_able_to(:destroy, create(:link, linkable: question)) }
    it { should_not be_able_to(:destroy, create(:link, linkable: othe_question)) }

    # File
    it { should be_able_to(:destroy, ActiveStorage::Attachment.create(record: question) ) }
    it { should_not be_able_to(:destroy, ActiveStorage::Attachment.create(record: othe_question) ) }
  end
end
