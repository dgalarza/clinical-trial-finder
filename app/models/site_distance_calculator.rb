class SiteDistanceCalculator
  def initialize(zip_code:, radius: Trial::DEFAULT_DISTANCE_RADIUS)
    @zip_code = ZipCode.find_by(zip_code: zip_code)
    @radius = radius
  end

  def nearby_trials(trial)
    if zip_code.present?
      trial_ids = site_pin_point.nearbys(radius).
        select(&:trial_id).map(&:trial_id).uniq

      trial.where(id: trial_ids).order_as_specified(id: trial_ids)
    else
      trial.order(:title)
    end
  end

  def closest_site(sites)
    return unless zip_code.present?

    if site = sites.near(zip_code.coordinates, radius).first
      distance = site.distance_from(zip_code.coordinates).round

      [site, distance]
    end
  end

  private

  attr_reader :zip_code, :radius

  def site_pin_point
    Site.new(latitude: zip_code.latitude, longitude: zip_code.longitude)
  end
end
