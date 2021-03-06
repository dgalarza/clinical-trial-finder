require "rails_helper"

RSpec.describe TrialPageHelper, type: :helper do
  describe "show_nearest_site?" do
    context "session zip_code_coordinates are set" do
      before do
        session[:zip_code_coordinates] = ["123", "456"]
      end

      context "site count is NOT 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 5)

          expect(helper_response).to be true
        end
      end

      context "site count is 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 1)

          expect(helper_response).to be true
        end
      end
    end

    context "session zip_code_coordinates are NOT set" do
      context "site count is NOT 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 5)

          expect(helper_response).to be false
        end
      end

      context "site count is 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 1)

          expect(helper_response).to be true
        end
      end
    end
  end

  describe "united_states_sites" do
    it "queries for ordered sites in the united states" do
      coordinates = double(:coordinates)
      trial = double(:trial)
      session[:zip_code_coordinates] = coordinates
      allow(trial).to receive(:ordered_sites).and_return([])

      united_states_sites(trial)

      expect(trial).to have_received(:ordered_sites).
        with(coordinates: coordinates, united_states: true)
    end

    it "wraps sites as presenters" do
      trial = double(:trial)
      site = build(:site)
      allow(trial).to receive(:ordered_sites).and_return([site])

      site_presenters = united_states_sites(trial)

      expect(site_presenters.first).to be_a SitePresenter
    end
  end

  describe "non_united_states_sites" do
    it "returns presenters for ordered sites outside of the united states" do
      coordinates = double(:coordinates)
      trial = double(:trial)
      session[:zip_code_coordinates] = coordinates
      allow(trial).to receive(:ordered_sites).and_return([])

      non_united_states_sites(trial)

      expect(trial).to have_received(:ordered_sites).
        with(coordinates: coordinates, united_states: false)
    end

    it "wraps sites as presenters" do
      trial = double(:trial)
      site = build(:site)
      allow(trial).to receive(:ordered_sites).and_return([site])

      site_presenters = non_united_states_sites(trial)

      expect(site_presenters.first).to be_a SitePresenter
    end
  end

  describe "coordinates" do
    it "returns coordinates values from session" do
      zip_code_coordinates = double(:zip_code_coordinates)
      session[:zip_code_coordinates] = zip_code_coordinates

      expect(coordinates).to eq zip_code_coordinates
    end
  end

  describe "load_resource_links" do
    context "resource responds successfully" do
      it "returns contents" do
        url = "http://test.com"
        with_environment "RESOURCE_LIST_URL" => url do
          inner_contents = "<ul><li>Item1</li></ul>"
          expected_contents = "<head></head><body><ul>#{inner_contents}"
          allow(RestClient).to receive(:get).with(url).
            and_return(expected_contents)

          expect(load_resource_links).to eq inner_contents
        end
      end
    end

    context "resource does NOT exist" do
      it "returns nil" do
        url = "http://test.com"
        with_environment "RESOURCE_LIST_URL" => url do
          allow(RestClient).to receive(:get).with(url).
            and_raise(RestClient::NotFound)

          expect(load_resource_links).to eq nil
        end
      end
    end
  end
end
