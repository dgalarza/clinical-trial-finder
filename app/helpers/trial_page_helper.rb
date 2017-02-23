module TrialPageHelper
  def show_nearest_site?(count:)
    session[:zip_code_coordinates].present? || (count == 1)
  end

  def united_states_sites(trial)
    site_presenters(trial, united_states: true)
  end

  def non_united_states_sites(trial)
    site_presenters(trial, united_states: false)
  end

  def coordinates
    session[:zip_code_coordinates]
  end

  def load_resource_links
    Rails.cache.fetch("resources", expires_in: 24.hours, cache_nils: false) do
      retrieve_resource_links
    end
  end

  private

  def site_presenters(trial, united_states:)
    trial.ordered_sites(coordinates: coordinates, united_states: united_states)
      .map do |site|
        SitePresenter.new(site)
      end
  end

  def retrieve_resource_links
    if inner_content.present?
      inner_content.first.inner_html
    end
  rescue RestClient::NotFound
    nil
  end

  def inner_content
    @inner_content ||= Nokogiri::HTML(link_url_content).css('ul')
  end

  def link_url_content
    RestClient.get ENV.fetch("RESOURCE_LIST_URL")
  end
end
