FactoryBot.define do
  factory :like do
    association :user
    association :likeable, factory: :question
    state { 1 }
  end
end
