FactoryGirl.define do
  factory :site do
    sequence(:facility) { |n| "Facility #{n}" }
    latitude 23.456
    longitude 78.901
    zip_code "07030"

    trait :us_based do
      country "United States"
    end

    trait :without_lat_long do
      latitude nil
      longitude nil
      zip_code nil
    end
  end
end
