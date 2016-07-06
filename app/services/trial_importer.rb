class TrialImporter
  def initialize(xml_file)
    @xml_file = xml_file
  end

  def import
    unless trial_unchanged?
      trial = Trial.find_or_initialize_by(nct_id: trial_nct_id)
      update_trial(trial)
      update_sites(trial)
      trial.save
    end
  end

  private

  attr_reader :xml_file

  def update_trial(trial)
    xml_mappings.each do |xml_mapping|
      value = root.xpath(xml_mapping.second).text
      trial.send("#{xml_mapping.first}=", value)
    end
  end

  def update_sites(trial)
    root.xpath("//location").each do |location|
      SiteImporter.new(trial: trial, site: location).import
    end
  end

  def trial_unchanged?
    last_import.present? && unchanged_since_last_import?
  end

  def unchanged_since_last_import?
    last_import_at > trial_last_changed_at
  end

  def last_import_at
    last_import.created_at.to_date
  end

  def trial_last_changed_at
    root.xpath("lastchanged_date").text.to_date
  end

  def trial_nct_id
    root.xpath(nct_id_xml_lookup).text
  end

  def last_import
    ImportLog.last
  end

  def xml_mappings
    [
      [:title, "brief_title"],
      [:nct_id, nct_id_xml_lookup],
      [:description, "detailed_description/textblock"],
      [:sponsor, "sponsors/lead_sponsor/agency"],
      [:gender, "//gender"],
      [:minimum_age_original, "//minimum_age"],
      [:maximum_age_original, "//maximum_age"]
    ]
  end

  def nct_id_xml_lookup
    "//nct_id"
  end

  def root
    @root ||= document.root
  end

  def document
    File.open(xml_file) { |f| Nokogiri::XML(f) }
  end
end
