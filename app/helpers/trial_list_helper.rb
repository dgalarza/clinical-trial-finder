module TrialListHelper
  MANY_TRIALS_COUNT = 30

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
    end.push(any_distance_radius)
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

  def show_intro?
    !filtered_results? && params["reset"].nil?
  end

  def show_many_trials?(trials)
    filtered_results? && trials.count > MANY_TRIALS_COUNT
  end

  def append_params(keyword)
    return unless filtered_results?
    appended_params = params.deep_dup
    trial_filter_form = appended_params["trial_filter_form"]
    trial_filter_form["keyword"] =
      [trial_filter_form["keyword"], keyword].compact.join(" ")

    appended_params.symbolize_keys
  end

  def filtered_results?
    params["trial_filter_form"].present?
  end

  private

  def any_distance_radius
    [t("helpers.search_filter.any_distance"), 20000]
  end

  def distance_radius(radius)
    t("helpers.search_filter.distance_radius", radius: radius)
  end

  def filter_params
    params.fetch("trial_filter_form", {})
  end
end
