class Trial < ActiveRecord::Base
  extend OrderAsSpecified

  ALL_GENDERS = "Both".freeze
  CONTROL_NEEDED = "Accepts Healthy Volunteers".freeze
  CONTROL_NOT_SPECIFIED = "".freeze
  MINIMUM_AGE = 0
  MAXIMUM_AGE = 120
  NOT_APPLICABLE = "N/A".freeze

  has_many :sites
  before_save :convert_ages

  scope :search_for, lambda { |query|
    where("title ILIKE :query OR description ILIKE :query", query: "%#{query}%")
  }

  scope :gender, lambda { |sex|
    where("gender IN (?)", [sex, ALL_GENDERS]) unless sex.blank?
  }

  scope :age, lambda { |age|
    where("minimum_age <= ? and maximum_age >= ?", age, age) unless age.blank?
  }

  scope :control, lambda { |control|
    if control == "true"
      where(healthy_volunteers: [CONTROL_NEEDED, CONTROL_NOT_SPECIFIED])
    end
  }

  scope :close_to, lambda { |zip_code|
    if zip_code.present?
      site_pin_point = build_site_pin_point(zip_code)
      nearby_sites = site_pin_point.nearbys(100)
      trial_ids = nearby_sites.map(&:trial_id).uniq
      where(id: trial_ids).order_as_specified(id: trial_ids)
    end
  }

  def closest_site(zip_code)
    zip_code = ZipCode.find_by(zip_code: zip_code)
    site = Site.where(trial_id: id).near(zip_code.coordinates, 100).first
    distance = site.distance_from(zip_code.coordinates).round

    [site, distance]
  end

  private

  def self.build_site_pin_point(zip_code)
    zip_code = ZipCode.find_by(zip_code: zip_code)
    Site.new(latitude: zip_code.latitude, longitude: zip_code.longitude)
  end
  private_class_method :build_site_pin_point

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
