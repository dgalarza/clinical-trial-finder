require "rails_helper"

RSpec.describe TrialsImporter do
  describe "#import" do
    it "gets zip folder from clinicaltrials.gov using config variables" do
      stub_zip_file
      condition = "brain tumor"
      remove_unknown = "Y"
      encoded_condition = "brain%20tumor"
      with_environment "CONDITION" => condition, "REMOVE_UNKNOWN" => remove_unknown do
        allow(RestClient).to receive(:get)

        TrialsImporter.new.import

        expect(RestClient).to have_received(:get)
          .with expected_url(encoded_condition, remove_unknown)
      end
    end

    it "saves zip folder as tmp file" do
      stub_file
      stub_zip_file

      TrialsImporter.new.import

      expect(File).to have_received(:open).with(tmp_file, "wb")
    end

    it "unzips tmp file" do
      stub_file
      stub_zip_file

      TrialsImporter.new.import

      expect(Zip::File).to have_received(:open).with(tmp_file)
    end

    it "passes each xml to TrialImporter" do
      stub_file
      trial_1 = double(:trial_1_xml_file).as_null_object
      trial_2 = double(:trial_2_xml_file).as_null_object
      unzipped_folder = [trial_1, trial_2]
      allow(Zip::File).to receive(:open).and_yield(unzipped_folder)
      importer = spy(:importer)
      allow(TrialImporter).to receive(:new)
        .with("tmp/#{trial_1}").and_return(importer)
      allow(TrialImporter).to receive(:new)
        .with("tmp/#{trial_2}").and_return(importer)

      TrialsImporter.new.import

      expect(importer).to have_received(:import).twice
    end
  end

  def expected_url(condition, remove_unknown)
    "http://clinicaltrials.gov/ct2/results/download?down_stds=all&down_typ=study&recr=Open&cond=#{condition}&show_down=Y&no_unk=#{remove_unknown}"
  end

  def tmp_file
    Rails.root.join("tmp/clinical_trials_download.zip")
  end

  def stub_zip_file
    allow(Zip::File).to receive(:open)
  end

  def stub_file
    allow(File).to receive(:open)
  end
end
