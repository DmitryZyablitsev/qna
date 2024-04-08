FactoryBot.define do
  factory :link do
    name { 'MyString' }
    url { 'https://thinknetica.com' }
    association :linkable, factory: :question
  end
end
