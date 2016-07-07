module SearchFilterHelper
  def filter_input_default(input)
    { input_html: { value: filter_params[input] } }
  end

  def filter_radio_default(input)
    { checked: filter_params[input] }
  end

  private

  def filter_params
    params.fetch(:trial_filter, {})
  end
end
