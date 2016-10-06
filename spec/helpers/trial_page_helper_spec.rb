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
      expected_sites = double(:expected_sites)
      session[:zip_code_coordinates] = coordinates
      allow(trial).to receive(:ordered_sites).
        with(coordinates: coordinates, united_states: true).
        and_return(expected_sites)

      trials = united_states_sites(trial)

      expect(trials).to eq expected_sites
    end
  end

  describe "non_united_states_sites" do
    it "queries for ordered sites outside of the united states" do
      coordinates = double(:coordinates)
      trial = double(:trial)
      expected_sites = double(:expected_sites)
      session[:zip_code_coordinates] = coordinates
      allow(trial).to receive(:ordered_sites).
        with(coordinates: coordinates, united_states: false).
        and_return(expected_sites)

      trials = non_united_states_sites(trial)

      expect(trials).to eq expected_sites
    end
  end

  describe "coordinates" do
    it "returns coordinates values from session" do
      zip_code_coordinates = double(:zip_code_coordinates)
      session[:zip_code_coordinates] = zip_code_coordinates

      expect(coordinates).to eq zip_code_coordinates
    end
  end
end
