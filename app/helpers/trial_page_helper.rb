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
    @load_resource_links ||= retrieve_resource_links
  end

  private

  def retrieve_resource_links
    if inner_content.present?
      inner_content.first.inner_html
    end
  rescue RestClient::NotFound
    nil
  end

  def inner_content
    Nokogiri::HTML(link_url_content).css('ul')
  end

  def link_url_content
    RestClient.get ENV.fetch("RESOURCE_LIST_URL")
  end
end
