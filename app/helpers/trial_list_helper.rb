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

  private

  def filter_params
    params.fetch("trial_filter", {})
  end
end
