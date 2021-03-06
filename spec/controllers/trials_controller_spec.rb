require "rails_helper"

RSpec.describe TrialsController, type: :controller do
  describe "#index" do
    context "form is valid" do
      it "caches all search params" do
        search_params = {
          "trial_filter_form" => { "age" => "10", "gender" => "M" }
        }
        stub_filter_form(valid: true)

        get :index, search_params

        expect(session[:search_params]).to eq search_params
      end

      it "caches all search params" do
        filter_form = stub_filter_form(valid: true)

        get :index

        expect(session[:search_results]).to eq filter_form.trial_ids
      end
    end

    context "form is invalid" do
      before do
        stub_filter_form(valid: false)
      end

      it "does NOT cache search params" do
        get :index

        expect(session[:search_params]).to eq nil
      end

      it "caches all search params" do
        get :index

        expect(session[:search_results]).to eq nil
      end

    end

    context "zip code is a search filter" do
      it "caches zip code coordinates" do
        coordinates = double(:coordinates)
        stub_filter_form(coordinates: coordinates)

        get :index

        expect(session[:zip_code_coordinates]).to eq coordinates
      end
    end

    context "zip code is NOT a search filter" do
      it "does NOT cache zip code coordinates and sets session to nil" do
        session[:zip_code_coordinates] = [123, 456]
        search_params = { "trial_filter_form" => { "zip_code" => "" } }

        get :index, search_params

        expect(session[:zip_code_coordinates]).to eq nil
      end
    end

    context "google utm parameters are included in url" do
      it "does NOT raise an error" do
        url_params = {
          "utm_source" => "source",
          "utm_content" => "content",
          "utm_medium" => "medium",
          "utm_campaign" => "campaign",
          "trial_filter_form" => {},
        }

        expect {
          get :index, url_params
        }.not_to raise_error
      end
    end
  end

  describe "#show" do
    context "google utm parameters are included in url" do
      it "does NOT raise an error" do
        @trial = create(:trial)
        url_params = {
          "utm_source" => "source",
          "utm_content" => "content",
          "utm_medium" => "medium",
          "utm_campaign" => "campaign",
          "id" => @trial.id,
        }

        expect {
          get :show, url_params
        }.not_to raise_error
      end
    end
  end

  def stub_filter_form(valid: true, coordinates: nil)
    trial_ids = double(:trial_ids)
    filter_form = double(
      :filter_form,
      valid?: valid,
      trial_ids: trial_ids,
      coordinates: coordinates,
    )
    allow(TrialFilterForm).to receive(:new).and_return(filter_form)

    filter_form
  end
end
