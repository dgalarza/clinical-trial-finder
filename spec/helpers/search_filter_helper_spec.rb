require "rails_helper"

RSpec.describe SearchFilterHelper, type: :helper do
  describe "#filter_input_default" do
    context "default values is present in params" do
      it "sets default value" do
        stubbed_params = { trial_filter: { age: 5 } }
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
        stubbed_params = { trial_filter: { gender: "Male" } }
        allow(helper).to receive(:params).and_return(stubbed_params)

        input_default = helper.filter_radio_default(:gender)

        expect(input_default).to eq(checked: "Male")
      end
    end

    context "params are not present" do
      it "sets default to nil" do
        empty_params = {}
        allow(helper).to receive(:params).and_return(empty_params)

        input_default = helper.filter_radio_default(:gender)

        expect(input_default).to eq(checked: nil)
      end
    end
  end
end
