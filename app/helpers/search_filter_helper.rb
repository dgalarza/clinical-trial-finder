module SearchFilterHelper
  def filter_input_default(input)
    { input_html: { value: filter_params[input] } }
  end

  def filter_radio_default(input)
    { checked: filter_params[input] }
  end

  def control_options
    [
      [t("helpers.search_filter.am_patient"), false],
      [t("helpers.search_filter.am_control"), true]
    ]
  end

  private

  def filter_params
    params.fetch(:trial_filter, {})
  end
end
