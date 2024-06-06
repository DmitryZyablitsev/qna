FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user, aliases: [:author] do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    rewards { [] }
    confirmed_at { '2024-06-06 22:30:45.121653778 +0500' }
  end
end
