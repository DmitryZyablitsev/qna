FactoryBot.define do
  sequence :name do |n|
    "MyLink_#{n}"
  end

  factory :link do
    name
    url { 'https://thinknetica.com' }
    # association :linkable, factory: :question
  end
end
