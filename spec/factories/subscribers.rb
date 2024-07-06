FactoryBot.define do
  factory :subscriber do
    association :user
    association :question
  end
end
