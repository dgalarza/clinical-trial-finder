FactoryGirl.define do
  factory :trial do
    sequence(:title) { |n| "Trial #{n}" }
    minimum_age_original "1 year"
    maximum_age_original "60 years"

    after(:build) do |trial|
      if trial.sites.empty?
        trial.sites << build(:site, trial: trial)
      end
    end

    trait :without_sites do
      after(:build) do |trial|
        trial.sites = []
      end
    end
  end
end
