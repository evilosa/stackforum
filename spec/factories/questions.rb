FactoryGirl.define do
  factory :question do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }

    trait :invalid do
      title nil
    end

    factory :question_with_answers do
      transient do
        answers_count 2
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, question: question)
      end
    end
  end
end
