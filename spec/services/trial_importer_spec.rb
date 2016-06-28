require "rails_helper"

RSpec.describe TrialImporter, type: :service do
  describe "#import" do
    it "parses xml to create Trial" do
      TrialImporter.new(trial_xml_file).import

      expect(Trial.all.count).to eq 1
      trial = Trial.first
      expect(trial.title).to eq "Brief Title"
      expect(trial.nct_id).to eq "NCT01234567"
      expect(trial.description).to include "Detailed Description"
      expect(trial.sponsor).to eq "Sponsor Agency"
    end
  end

  def trial_xml_file
    Rails.root.join("spec", "fixtures", "trial_import.xml")
  end
end
