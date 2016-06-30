require "rails_helper"

RSpec.describe TrialImporter, type: :service do
  describe "#import" do
    context "trial was NOT imported" do
      it "maps attributes to create a Trial" do
        spy_on_site_importer

        TrialImporter.new(trial_xml_file).import

        expect(Trial.all.count).to eq 1
        trial = Trial.first
        expect(trial.title).to eq "Brief Title"
        expect(trial.nct_id).to eq trial_nct_id
        expect(trial.description).to include "Detailed Description"
        expect(trial.sponsor).to eq "Sponsor Agency"
      end

      it "imports sites from '//locations'" do
        site_importer_spy = spy_on_site_importer

        TrialImporter.new(trial_xml_file).import

        expect(site_importer_spy).to have_received(:import).twice
      end
    end

    context "trial was last changed before the last import" do
      it "does NOT create/modify Trial or Sites" do
        previously_imported_trial = create(:trial, nct_id: trial_nct_id)
        site_importer_spy = spy_on_site_importer
        ImportLog.create(created_at: trial_last_changed_date + 1.day)

        TrialImporter.new(trial_xml_file).import

        expect(Trial.all.count).to eq 1
        trial = Trial.first
        expect(trial.title).to eq previously_imported_trial.title
        expect(site_importer_spy).not_to have_received(:import)
      end
    end

    context "trial was last changed after the last import" do
      it "modifies existing Trial and Sites" do
        previously_imported_trial = create(:trial, nct_id: trial_nct_id)
        site_importer_spy = spy_on_site_importer
        ImportLog.create(created_at: trial_last_changed_date - 1.day)

        TrialImporter.new(trial_xml_file).import

        expect(Trial.all.count).to eq 1
        trial = Trial.first
        expect(trial.title).not_to eq previously_imported_trial.title
        expect(site_importer_spy).to have_received(:import).twice
      end
    end

    context "trial was last changed the same day as the last import" do
      it "modifies existing Trial and Sites" do
        previously_imported_trial = create(:trial, nct_id: trial_nct_id)
        site_importer_spy = spy_on_site_importer
        ImportLog.create(created_at: trial_last_changed_date)

        TrialImporter.new(trial_xml_file).import

        expect(Trial.all.count).to eq 1
        trial = Trial.first
        expect(trial.title).not_to eq previously_imported_trial.title
        expect(site_importer_spy).to have_received(:import).twice
      end
    end
  end

  def trial_nct_id
    "NCT01234567"
  end

  def trial_last_changed_date
    Date.new(2016, 5, 13)
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
