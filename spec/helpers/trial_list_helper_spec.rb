require "rails_helper"

RSpec.describe TrialListHelper, type: :helper do
  describe "#zip_code_param" do
    context "zip code is a filter parameter" do
      it "returns param" do
        zip_code_param = double(:zip_code_param)
        stubbed_params = { "trial_filter" => { "zip_code" => zip_code_param } }
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
        stubbed_params = { "trial_filter" => { "age" => 5 } }
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
        stubbed_params = { "trial_filter" => { "gender" => "Male" } }
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

  describe "#distance_radius_options" do
    it "returns options for distance_radius" do
      options = helper.distance_radius_options

      expect(options).to eq [
        [t("helpers.search_filter.distance_radius", radius: 25), 25],
        [t("helpers.search_filter.distance_radius", radius: 50), 50],
        [t("helpers.search_filter.distance_radius", radius: 100), 100],
        [t("helpers.search_filter.distance_radius", radius: 300), 300],
        [t("helpers.search_filter.distance_radius", radius: 500), 500]
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
        stubbed_params = { "trial_filter" => { "distance_radius" => "50" } }
        allow(helper).to receive(:params).and_return(stubbed_params)

        expect(helper.distance_radius_selected_value).to eq 50
      end
    end
  end
end
