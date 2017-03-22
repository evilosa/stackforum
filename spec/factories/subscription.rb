FactoryGirl.define do
  factory :subscription do
    user
    association :subscribable
  end
end
