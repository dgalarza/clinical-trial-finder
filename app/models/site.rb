class Site < ActiveRecord::Base
  belongs_to :trial, counter_cache: true

  MAXIMUM_FACILITY_LENGTH = 40

  geocoded_by :address
  after_validation(
    :geocode,
    if: :should_be_geocoded?,
  )

  def self.without_coordinates
    where("latitude IS NULL or longitude IS NULL")
  end

  def facility_address
    "#{facility} #{address}".gsub("&", "and")
  end

  def address
    [city, state, country, zip_code].select(&:present?).join(", ")
  end

  def in_united_states?
    country == "United States"
  end

  def display_location
    locations_to_include = [city, state]

    unless facility_too_long?
      locations_to_include.unshift(facility)
    end

    unless in_united_states?
      locations_to_include << country
    end

    locations_to_include.select(&:present?).join(", ")
  end

  def should_be_geocoded?
    no_coordinates? && address.present? && geocoding_enabled?
  end

  def no_coordinates?
    latitude.nil? && longitude.nil?
  end

  def geocoding_enabled?
    ENV["DISABLE_SITE_GEOCODING"] != "true"
  end

  private

  def facility_too_long?
    facility.length > MAXIMUM_FACILITY_LENGTH
  end
end
