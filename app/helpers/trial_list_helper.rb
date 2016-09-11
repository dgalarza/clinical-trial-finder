module TrialListHelper
  def zip_code_param
    filter_params["zip_code"]
  end

  def filter_input_default(input)
    { input_html: { value: filter_params[input.to_s] } }
  end

  def filter_radio_default(input)
    { checked: filter_params[input.to_s] }
  end

  def control_options
    [
      [t("helpers.search_filter.am_patient"), false],
      [t("helpers.search_filter.am_control"), true]
    ]
  end

  def study_type_options
    [
      [t("helpers.search_filter.observational"), "Observational"],
      [t("helpers.search_filter.interventional"), "Interventional"]
    ]
  end

  def distance_radius_options
    [25, 50, 100, 300, 500].map do |distance|
      [distance_radius(distance), distance]
    end
  end

  def distance_radius_selected_value
    filter_params.fetch("distance_radius", Trial::DEFAULT_DISTANCE_RADIUS).to_i
  end

  def distance_from_site(site)
    if zip_code_coordinates = session[:zip_code_coordinates]
      if distance = site.distance_from(zip_code_coordinates)
        t("trials.miles_away", count: distance.round())
      end
    end
  end

  private

  def distance_radius(radius)
    t("helpers.search_filter.distance_radius", radius: radius)
  end

  def filter_params
    params.fetch("trial_filter", {})
  end
end
