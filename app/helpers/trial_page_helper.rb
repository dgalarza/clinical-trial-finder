module TrialPageHelper
  def show_nearest_site?(count:)
    session[:zip_code_coordinates].present? || (count == 1)
  end

  def united_states_sites(trial)
    trial.ordered_sites(coordinates: coordinates, united_states: true)
  end

  def non_united_states_sites(trial)
    trial.ordered_sites(coordinates: coordinates, united_states: false)
  end

  def coordinates
    session[:zip_code_coordinates]
  end
end
