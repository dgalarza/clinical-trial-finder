require "rails_helper"

RSpec.describe TrialImporter, type: :service do
  describe "#import" do
    context "trial was NOT imported" do
      it "maps attributes to create a Trial" do
        spy_on_site_importer

        TrialImporter.new(trial_xml).import

        expect(Trial.all.count).to eq 1
        trial = Trial.first
        expect(trial.agency_class).to eq "Agency Class"
        expect(trial.conditions).to eq ["Condition1", "Condition2"]
        expect(trial.countries).to eq ["Country"]
        expect(trial.criteria).to include "Criteria"
        expect(trial.description).to include "Detailed Description"
        expect(trial.detailed_description).to include "Detailed Description"
        expect(trial.first_received_date).to eq "First Received Date"
        expect(trial.gender).to eq "Gender"
        expect(trial.has_expanded_access).to eq "Has Expanded Access"
        expect(trial.healthy_volunteers).to eq "Healthy Volunteers"
        expect(trial.is_fda_regulated).to eq "Is Fda Regulated"
        expect(trial.keywords).to eq ["Keyword1", "Keyword2"]
        expect(trial.last_changed_date).to eq "May 13, 2016"
        expect(trial.link_description).to eq "Link Description"
        expect(trial.link_url).to eq "Link Url"
        expect(trial.maximum_age_original).to eq "Maximum Age"
        expect(trial.minimum_age_original).to eq "Minimum Age"
        expect(trial.nct_id).to eq trial_nct_id
        expect(trial.official_title).to eq "Official Title"
        expect(trial.overall_contact_name).to eq "Overall Contact Name"
        expect(trial.overall_contact_phone).to eq "Overall Contact Phone"
        expect(trial.overall_status).to eq "Overall Status"
        expect(trial.phase).to eq "Phase"
        expect(trial.sponsor).to eq "Sponsor Agency"
        expect(trial.study_type).to eq "Study Type"
        expect(trial.title).to eq "Brief Title"
        expect(trial.verification_date).to eq "Verification Date"
      end

      it "imports sites from '//locations'" do
        site_importer_spy = spy_on_site_importer

        TrialImporter.new(trial_xml).import

        expect(site_importer_spy).to have_received(:import).twice
      end
    end

    context "trial was last changed before the last import" do
      it "does NOT create/modify Trial or Sites" do
        previously_imported_trial = create(:trial, nct_id: trial_nct_id)
        site_importer_spy = spy_on_site_importer
        ImportLog.create(created_at: trial_last_changed_date + 1.day)

        TrialImporter.new(trial_xml).import

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

        TrialImporter.new(trial_xml).import

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

        TrialImporter.new(trial_xml).import

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

  def trial_xml
    Rails.root.join("spec", "fixtures", "trial_with_two_sites_import.xml")
  end

  def trial_xml_without_ages
    Rails.root.join("spec", "fixtures", "trial_without_ages.xml")
  end

  def spy_on_site_importer
    site_importer_spy = spy(:site_importer)
    allow(SiteImporter).to receive(:new).and_return(site_importer_spy)

    site_importer_spy
  end
end
