class Site < ActiveRecord::Base
  belongs_to :trial, counter_cache: true

  geocoded_by :address
  after_validation(
    :geocode,
    if: ->(site) { site.address.present? }
  )

  def facility_address
    "#{facility} #{address}"
  end

  def address
    [city, state, country, zip_code].select(&:present?).join(", ")
  end
end
