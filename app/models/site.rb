class Site < ActiveRecord::Base
  belongs_to :trial, counter_cache: true

  geocoded_by :address
  after_validation(
    :geocode,
    if: ->(site) { site.address.present? }
  )

  def address
    if city.present? && state.present? && country.present? && zip_code.present?
      "#{city}, #{state} #{country} #{zip_code}"
    end
  end
end
