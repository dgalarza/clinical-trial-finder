require "zip"

class TrialsImporter
  def initialize
    clear_import_files
  end

  def import
    retrieve_zip_file
    import_zip_file
    create_import_log
  end

  private

  def retrieve_zip_file
    File.open(tmp_zipfile, "wb") do |file|
      file.write RestClient.get clinical_trials_gov_url
    end
  end

  def import_zip_file
    Zip::File.open(tmp_zipfile) do |unzipped_folder|
      unzipped_folder.each do |xml_file|
        tmp_file = directory.join(xml_file.name)
        xml_file.extract(tmp_file)
        TrialImporter.new(tmp_file).import
      end
    end
  end

  def create_import_log
    ImportLog.create(counts)
  end

  def counts
    { trial_count: Trial.all.count, site_count: Site.all.count }
  end

  def clear_import_files
    FileUtils.rm_rf Dir.glob("#{directory}/*")
  end

  def tmp_zipfile
    directory.join("clinical_trials_download.zip")
  end

  def directory
    directory = Rails.root.join("tmp", "import_files")

    unless directory.exist?
      Dir.mkdir(directory)
    end

    directory
  end

  def clinical_trials_gov_url
    "http://clinicaltrials.gov/ct2/results/download?down_stds=all&down_typ=study&recr=Open&cond=#{encoded_condition}&show_down=Y&no_unk=#{remove_unknown}"
  end

  def remove_unknown
    ENV.fetch("REMOVE_UNKNOWN")
  end

  def encoded_condition
    URI.encode ENV.fetch("CONDITION")
  end
end
