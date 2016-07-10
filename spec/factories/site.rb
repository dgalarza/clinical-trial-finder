FactoryGirl.define do
  factory :site do
    sequence(:facility) { |n| "Facility #{n}" }
  end
end
