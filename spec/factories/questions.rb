FactoryBot.define do
  sequence :title do |n|
    "MyString#{n}"
  end

  factory :question do
    title
    body
    association :author

    trait :invalid do
      title { nil }
    end
  end
end
