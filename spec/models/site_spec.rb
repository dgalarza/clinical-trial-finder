require "rails_helper"

RSpec.describe Site, type: :model do
  describe "Associations" do
    it { is_expected.to belong_to(:trial) }
  end

  describe "#phone_to_call" do
    context "extension exists" do
      it "returns phone , extension" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: "5076"
        )

        expect(site.phone_to_call).to eq "2345678901,5076"
      end
    end

    context "extension does NOT exist" do
      it "returns phone" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: ""
        )

        expect(site.phone_to_call).to eq "2345678901"
      end
    end
  end

  describe "#phone_as_text" do
    context "extension exists" do
      it "returns phone , extension" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: "5076"
        )

        expect(site.phone_as_text).to eq "2345678901 #5076"
      end
    end

    context "extension does NOT exist" do
      it "returns phone" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: ""
        )

        expect(site.phone_as_text).to eq "2345678901"
      end
    end
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

        expect(site.address).to eq "City, State, Country, Zip Code"
      end
    end

    context "some address fields exist" do
      it "returns available fields" do
        site = build(
          :site,
          city: "City",
          state: "",
          country: "Country",
          zip_code: "Zip Code"
        )

        expect(site.address).to eq "City, Country, Zip Code"
      end
    end

    context "address fields do NOT exist" do
      it "returns empty string" do
        site = build(
          :site,
          city: "",
          state: "",
          country: "",
          zip_code: ""
        )

        expect(site.address).to eq ""
      end
    end
  end

  describe ".in_united_states?" do
    context "site based in United States" do
      it "returns true" do
        site = build(:site, country: "United States")

        expect(site.in_united_states?).to be true
      end
    end

    context "site NOT based in United States" do
      it "returns false" do
        site = build(:site, country: "France")

        expect(site.in_united_states?).to be false
      end
    end
  end

  describe ".display_location" do
    context "based in United States" do
      it "does NOT include country" do
        site = build(
          :site,
          facility: "Facility",
          city: "City",
          state: "State",
          country: "United States",
          zip_code: "Zip Code"
        )

        expect(site.display_location).to eq "Facility, City, State"
      end
    end

    context "based outside of the United States" do
      it "does include country" do
        site = build(
          :site,
          facility: "Facility",
          city: "City",
          state: "State",
          country: "France",
          zip_code: "Zip Code"
        )

        expect(site.display_location).to eq "Facility, City, State, France"
      end
    end

    context "facility name is too long to display" do
      it "does NOT include facility name" do
        facility = "For additional information regarding investigative sites..."
        site = build(
          :site,
          facility: facility,
          city: "City",
          state: "State",
          country: "United States",
          zip_code: "Zip Code"
        )

        expect(site.display_location).to eq "City, State"
      end
    end
  end
end
