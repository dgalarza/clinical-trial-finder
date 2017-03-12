class Trial < ActiveRecord::Base
  extend OrderAsSpecified
  include PgSearch

  ALL_GENDERS = "Both".freeze
  CONTROL_NEEDED = "Accepts Healthy Volunteers".freeze
  CONTROL_NOT_SPECIFIED = "".freeze
  DEFAULT_DISTANCE_RADIUS = 100
  MINIMUM_AGE = 0
  MAXIMUM_AGE = 120
  NOT_APPLICABLE = "N/A".freeze
  OBSERVATIONAL_STUDY_TYPES =
    "('Observational', 'Observational [Patient Registry]')".freeze

  has_many :sites
  before_save :convert_ages

  pg_search_scope(
    :search,
    against: %i(tsv),
    using: { tsearch: { dictionary: "english" } },
  )

  scope :search_for, lambda { |query|
    search(query) unless query.blank?
  }

  scope :gender, lambda { |sex|
    where("gender IN (?)", [sex, ALL_GENDERS]) unless sex.blank?
  }

  scope :study_type, lambda { |study_type|
    if study_type == "Interventional"
      where("study_type = 'Interventional'")
    elsif study_type == "Observational"
      where("study_type IN #{OBSERVATIONAL_STUDY_TYPES}")
    end
  }

  scope :age, lambda { |age|
    where("minimum_age <= ? and maximum_age >= ?", age, age) unless age.blank?
  }

  scope :control, lambda { |control|
    if control == "true"
      where(healthy_volunteers: [CONTROL_NEEDED, CONTROL_NOT_SPECIFIED])
    end
  }

  scope :close_to, lambda { |zip_code:, radius:|
    SiteDistanceCalculator.new(zip_code: zip_code, radius: radius).
      nearby_trials(self)
  }

  def closest_site(zip_code)
    SiteDistanceCalculator.new(zip_code: zip_code).closest_site(sites)
  end

  def ordered_sites(coordinates: nil, united_states: nil)
    filtered_sites = filter_sites_by_country(united_states)
    if coordinates.present?
      sort_by_distance(filtered_sites, coordinates)
    else
      filtered_sites
    end
  end

  private

  def filter_sites_by_country(united_states)
    if united_states.nil?
      sites
    else
      filter_type = united_states ? "select" : "reject"
      sites.send(filter_type, &:in_united_states?)
    end
  end

  def sort_by_distance(sites, coordinates)
    sites.sort_by do |site|
      if distance = site.distance_from(coordinates)
        distance
      else
        Float::INFINITY
      end
    end
  end

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
