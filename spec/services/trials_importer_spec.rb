require "rails_helper"

RSpec.describe TrialsImporter do
  before do
    make_tmp_directory
  end

  describe "#initialize" do
    it "removes all existing files from tmp folder" do
      stub_zip_file
      allow(RestClient).to receive(:get)
      make_import_files_directory
      File.new(tmp_file, "w+")
      file_present = File.exist? tmp_file
      expect(file_present).to be true

      TrialsImporter.new

      file_present = File.exist? tmp_file
      expect(file_present).to be false
    end
  end

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

    it "passes each xml file to TrialImporter" do
      stub_file
      trial_1 = double(:trial_1_xml_file).as_null_object
      trial_1_path = directory.join(trial_1)
      trial_2 = double(:trial_2_xml_file).as_null_object
      trial_2_path = directory.join(trial_2)
      unzipped_folder = [trial_1, trial_2]
      allow(Zip::File).to receive(:open).and_yield(unzipped_folder)
      importer = spy(:importer)
      allow(TrialImporter).to receive(:new)
        .with(trial_1_path).and_return(importer)
      allow(TrialImporter).to receive(:new)
        .with(trial_2_path).and_return(importer)

      TrialsImporter.new.import

      expect(importer).to have_received(:import).twice
    end

    it "creates an Import record with trial and site count" do
      trial = create(:trial)
      3.times { create(:site, trial: trial) }
      stub_file
      stub_zip_file

      TrialsImporter.new.import

      expect(ImportLog.all.count).to eq 1
      import_log = ImportLog.first

      expect(import_log.site_count).to eq 3
      expect(import_log.trial_count).to eq 1
    end
  end

  def expected_url(condition, remove_unknown)
    "http://clinicaltrials.gov/ct2/results/download?down_stds=all&down_typ=study&recr=Open&cond=#{condition}&show_down=Y&no_unk=#{remove_unknown}"
  end

  def tmp_file
    directory.join("clinical_trials_download.zip")
  end

  def make_import_files_directory
    unless directory.exist?
      Dir.mkdir(directory)
    end
  end

  def make_tmp_directory
    unless tmp_directory.exist?
      Dir.mkdir(tmp_directory)
    end
  end

  def directory
    tmp_directory.join("import_files")
  end

  def tmp_directory
    Rails.root.join("tmp")
  end

  def stub_zip_file
    allow(Zip::File).to receive(:open)
  end

  def stub_file
    allow(File).to receive(:open)
  end
end
