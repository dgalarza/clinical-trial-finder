require "rails_helper"

RSpec.describe TrialsController, type: :controller do
  describe "#index" do
    it "caches all search params" do
      search_params = { "trial_filter" => { "age" => "10", "gender" => "M" } }

      get :index, search_params

      expect(session[:search_params]).to eq search_params
    end

    context "zip code is a search filter" do
      it "caches zip code coordinates" do
        zip_code = "12345"
        coordinates = double(:coordinates)
        search_params = { "trial_filter" => { "zip_code" => zip_code } }
        zip_code_object =
          double(:zip_code_object, coordinates: coordinates).as_null_object
        allow(ZipCode).to receive(:find_by).with(zip_code: zip_code).
          and_return(zip_code_object)

        get :index, search_params

        expect(session[:zip_code_coordinates]).to eq coordinates
      end
    end

    context "zip code is NOT a search filter" do
      it "does NOT cache zip code coordinates and sets session to nil" do
        session[:zip_code_coordinates] = [123, 456]
        search_params = { "trial_filter" => { "zip_code" => "" } }

        get :index, search_params

        expect(session[:zip_code_coordinates]).to eq nil
      end
    end
  end
end
