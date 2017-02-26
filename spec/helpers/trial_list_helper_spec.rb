require "rails_helper"

RSpec.describe TrialListHelper, type: :helper do
  describe "#zip_code_param" do
    context "zip code is a filter parameter" do
      it "returns param" do
        zip_code_param = double(:zip_code_param)
        stubbed_params =
          { "trial_filter_form" => { "zip_code" => zip_code_param } }
        allow(helper).to receive(:params).and_return(stubbed_params)

        expect(helper.zip_code_param).to eq zip_code_param
      end
    end

    context "there are no filter parameters" do
      it "returns nil" do
        stubbed_params = {}
        allow(helper).to receive(:params).and_return(stubbed_params)

        expect(helper.zip_code_param).to eq nil
      end
    end
  end

  describe "#filter_input_default" do
    context "default values is present in params" do
      it "sets default value" do
        stubbed_params = { "trial_filter_form" => { "age" => 5 } }
        allow(helper).to receive(:params).and_return(stubbed_params)

        input_default = helper.filter_input_default(:age)

        expect(input_default).to eq(input_html: { value: 5 })
      end
    end

    context "params are not present" do
      it "sets default to nil" do
        empty_params = {}
        allow(helper).to receive(:params).and_return(empty_params)

        input_default = helper.filter_input_default(:age)

        expect(input_default).to eq(input_html: { value: nil })
      end
    end
  end

  describe "#filter_radio_default" do
    context "default values is present in params" do
      it "sets default value" do
        stubbed_params = { "trial_filter_form" => { "gender" => "Male" } }
        allow(helper).to receive(:params).and_return(stubbed_params)

        input_default = helper.filter_radio_default(:gender)

        expect(input_default).to eq(checked: "Male")
      end
    end

    context "params are NOT present" do
      it "sets default to nil" do
        empty_params = {}
        allow(helper).to receive(:params).and_return(empty_params)

        input_default = helper.filter_radio_default(:gender)

        expect(input_default).to eq(checked: nil)
      end
    end
  end

  describe "#control_options" do
    it "returns options for control input" do
      options = helper.control_options

      expect(options).to eq [
        [t("helpers.search_filter.am_patient"), false],
        [t("helpers.search_filter.am_control"), true]
      ]
    end
  end

  describe "#study_type_options" do
    it "returns options for study_type input" do
      options = helper.study_type_options

      expect(options).to eq [
        [t("helpers.search_filter.observational"), "Observational"],
        [t("helpers.search_filter.interventional"), "Interventional"]
      ]
    end
  end

  describe "#distance_radius_options" do
    it "returns options for distance_radius" do
      options = helper.distance_radius_options

      expect(options).to eq [
        [t("helpers.search_filter.distance_radius", radius: 25), 25],
        [t("helpers.search_filter.distance_radius", radius: 50), 50],
        [t("helpers.search_filter.distance_radius", radius: 100), 100],
        [t("helpers.search_filter.distance_radius", radius: 300), 300],
        [t("helpers.search_filter.distance_radius", radius: 500), 500],
        [t("helpers.search_filter.any_distance"), 20000],
      ]
    end
  end

  describe "#distance_radius_selected_value" do
    context "params are NOT present" do
      it "returns default distance radius" do
        empty_params = {}
        allow(helper).to receive(:params).and_return(empty_params)

        expect(helper.distance_radius_selected_value)
          .to eq Trial::DEFAULT_DISTANCE_RADIUS
      end
    end

    context "params are present" do
      it "returns distance radius from param as integer" do
        stubbed_params =
          { "trial_filter_form" => { "distance_radius" => "50" } }
        allow(helper).to receive(:params).and_return(stubbed_params)

        expect(helper.distance_radius_selected_value).to eq 50
      end
    end
  end

  describe "#distance_from_site" do
    context "zip code coordinates session is nil" do
      it "returns nil" do
        site = double(:site)
        session[:zip_code_coordinates] = nil

        expect(helper.distance_from_site(site)).to eq nil
      end
    end

    context "zip code coordinates session is set" do
      it "returns miles away with count" do
        site = build(:site)
        coordinates = [123, 456]
        miles_away = 12.3456
        session[:zip_code_coordinates] = coordinates
        allow(site).to receive(:distance_from).with(coordinates).
          and_return(miles_away)

        expected_response = helper.distance_from_site(site)

        expect(expected_response).to eq t("trials.miles_away", count: 12)
      end

      context "site does not have latitude longitude" do
        it "returns nil" do
          site = build(:site, latitude: nil, longitude: nil)
          coordinates = [123, 456]
          session[:zip_code_coordinates] = coordinates

          expected_response = helper.distance_from_site(site)

          expect(expected_response).to eq nil
        end
      end
    end
  end

  describe "show_intro?" do
    context "search params are present" do
      it "returns false" do
        params["trial_filter_form"] = double(:filter)

        expect(helper.show_intro?).to be false
      end
    end

    context "search params are NOT present" do
      context "reset filter params are not present" do
        it "returns true" do
          params["controller"] = "trials"
          params["action"] = "index"

          expect(helper.show_intro?).to be true
        end
      end

      context "reset filter params are present" do
        it "returns false" do
          params["controller"] = "trials"
          params["action"] = "index"
          params["reset"] = true

          expect(helper.show_intro?).to be false
        end
      end
    end
  end

  describe "filtered_results?" do
    context "search params are present" do
      it "returns false" do
        params["trial_filter_form"] = double(:filter)

        expect(helper.show_intro?).to be false
      end
    end

    context "search params are NOT present" do
      it "returns true" do
        params["controller"] = "trials"
        params["action"] = "index"

        expect(helper.show_intro?).to be true
      end
    end
  end
end
