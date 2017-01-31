FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    question
  end
end
