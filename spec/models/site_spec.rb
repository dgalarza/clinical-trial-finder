require "rails_helper"

RSpec.describe Site, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:trial) }
  end

  describe "#address" do
    context "address fields exist" do
      it "returns site's address" do
        site = build(
          :site,
          city: "City",
          state: "State",
          country: "Country",
          zip_code: "Zip Code"
        )

        expect(site.address).to eq "City, State Country Zip Code"
      end
    end

    context "address fields do NOT exist" do
      it "returns nil" do
        site = build(
          :site,
          city: "",
          state: "",
          country: "",
          zip_code: ""
        )

        expect(site.address).to eq nil
      end
    end
  end
end
