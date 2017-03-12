FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    commentable
    user
  end
end
