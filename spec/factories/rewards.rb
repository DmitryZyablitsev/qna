FactoryBot.define do
  factory :reward do
    name { 'Test Reward' }
    association :user
    association :question
    image { Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, 'public/img/reward.jpg'))) }
  end
end
