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
      value = fetch_field_value(xml_mapping)
      trial.send("#{xml_mapping.first}=", value)
    end
  end

  def fetch_field_value(xml_mapping)
    xpath_tag = root.xpath(xml_mapping.second)

    if database_attribute_is_array?(xml_mapping.first)
      xpath_tag.map(&:text)
    else
      xpath_tag.text
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

  def database_attribute_is_array?(key)
    Trial.columns_hash[key.to_s].array
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
      [:agency_class, "//agency_class"],
      [:conditions, "condition"],
      [:countries, "location_countries/country"],
      [:criteria, "//criteria/textblock"],
      [:description, "detailed_description/textblock"],
      [:detailed_description, "detailed_description/textblock"],
      [:first_received_date, "firstreceived_date"],
      [:gender, "//gender"],
      [:has_expanded_access, "has_expanded_access"],
      [:healthy_volunteers, "//healthy_volunteers"],
      [:is_fda_regulated, "is_fda_regulated"],
      [:keywords, "keyword"],
      [:last_changed_date, "lastchanged_date"],
      [:link_description, "//link/description"],
      [:link_url, "//link/url"],
      [:maximum_age_original, "//maximum_age"],
      [:minimum_age_original, "//minimum_age"],
      [:nct_id, nct_id_xml_lookup],
      [:official_title, "official_title"],
      [:overall_contact_name, "//overall_contact/last_name"],
      [:overall_contact_phone, "//overall_contact/phone"],
      [:overall_status, "//overall_status"],
      [:phase, "//phase"],
      [:sponsor, "sponsors/lead_sponsor/agency"],
      [:study_type, "//study_type"],
      [:title, "brief_title"],
      [:verification_date, "verification_date"]
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
