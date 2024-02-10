FactoryBot.define do
  sequence :body do |n|
    "Answer#{n}Text"
  end

  factory :answer do
    body
    association :question
    association :author

    trait :invalid do
      body { nil }
    end
  end
end
