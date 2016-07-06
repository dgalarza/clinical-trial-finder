FactoryGirl.define do
  factory :trial do
    sequence(:title) { |n| "Trial #{n}" }
    minimum_age_original "1 year"
    maximum_age_original "60 years"
  end
end
