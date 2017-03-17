FactoryGirl.define do
  factory :comment do
    body { Faker::Lorem.paragraph }
    commentable { :question }
    user
  end
end
