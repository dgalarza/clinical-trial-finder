FactoryGirl.define do
  factory :site do
    sequence(:facility) { |n| "Facility #{n}" }
    latitude 23.456
    longitude 78.901

    trait :us_based do
      country "United States"
    end
  end
end
