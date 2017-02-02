FactoryGirl.define do
  factory :answer do
    body { Faker::Lorem.paragraph }
    question

    trait :invalid do
      body nil
    end
  end
end
