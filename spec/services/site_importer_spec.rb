require "rails_helper"

RSpec.describe SiteImporter, type: :service do
  describe "#import" do
    it "creates Site associated with Trial" do
      trial = build(:trial)

      SiteImporter.new(trial: trial, site: site_in_nokogiri).import

      expect(trial.sites.count).to eq 1
    end

    it "maps attributes to create Site" do
      trial = build(:trial)

      SiteImporter.new(trial: trial, site: site_in_nokogiri).import

      site = Site.first
      expect(site.facility).to eq "Facility Name"
      expect(site.city).to eq "City"
      expect(site.state).to eq "State"
      expect(site.country).to eq "Country"
      expect(site.zip_code).to eq "Zip Code"
      expect(site.status).to eq "Status"
      expect(site.contact_name).to eq "Contact Name"
      expect(site.contact_phone).to eq "Phone"
      expect(site.contact_phone_ext).to eq "Phone Ext"
      expect(site.contact_email).to eq "Email"
    end
  end

  def site_in_nokogiri
    File.open(site_fixture) { |f| Nokogiri::XML(f) }.root
  end

  def site_fixture
    Rails.root.join("spec", "fixtures", "site_import.xml")
  end
end
