require "rails_helper"

RSpec.describe TrialImporter, type: :service do
  describe "#import" do
    it "maps attributes to create a Trial" do
      spy_on_site_importer

      TrialImporter.new(trial_xml_file).import

      expect(Trial.all.count).to eq 1
      trial = Trial.first
      expect(trial.title).to eq "Brief Title"
      expect(trial.nct_id).to eq "NCT01234567"
      expect(trial.description).to include "Detailed Description"
      expect(trial.sponsor).to eq "Sponsor Agency"
    end

    it "imports sites from '//locations'" do
      site_importer_spy = spy_on_site_importer

      TrialImporter.new(trial_xml_file).import

      expect(site_importer_spy).to have_received(:import).twice
    end
  end

  def trial_xml_file
    Rails.root.join("spec", "fixtures", "trial_with_two_sites_import.xml")
  end

  def spy_on_site_importer
    site_importer_spy = spy(:site_importer)
    allow(SiteImporter).to receive(:new).and_return(site_importer_spy)

    site_importer_spy
  end
end
