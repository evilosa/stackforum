FactoryGirl.define do
  factory :vote do
    votable
    user
    status 1
  end
end
