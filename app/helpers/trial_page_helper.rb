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

  def load_resource_links
    @load_resource_links ||= retrive_resource_links
  end

  private

  def retrive_resource_links
    RestClient.get(ENV.fetch("RESOURCE_LIST_URL"))
  rescue RestClient::NotFound
    nil
  end
end
