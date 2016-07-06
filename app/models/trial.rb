class Trial < ActiveRecord::Base
  MINIMUM_AGE = 0
  MAXIMUM_AGE = 120
  NOT_APPLICABLE = "N/A".freeze

  has_many :sites
  before_save :convert_ages

  scope :search_for, lambda { |query|
    where("title ILIKE :query OR description ILIKE :query", query: "%#{query}%")
  }

  scope :age, lambda { |age|
    where("minimum_age <= ? and maximum_age >= ?", age, age) unless age.blank?
  }

  private

  def convert_ages
    self.minimum_age = converted_minimum_age_original
    self.maximum_age = converted_maximum_age_original
  end

  def converted_minimum_age_original
    if minimum_age_original == NOT_APPLICABLE
      MINIMUM_AGE
    else
      convert_months_to_years(minimum_age_original)
    end
  end

  def converted_maximum_age_original
    if maximum_age_original == NOT_APPLICABLE
      MAXIMUM_AGE
    else
      convert_months_to_years(maximum_age_original)
    end
  end

  def convert_months_to_years(age)
    if age =~ /month/i
      age.to_i / 12
    else
      age
    end
  end
end
