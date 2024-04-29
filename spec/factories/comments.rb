FactoryBot.define do
  factory :comment do
    association :user
    association :commentable, factory: :question
    body { 'My comment' }
  end
end
