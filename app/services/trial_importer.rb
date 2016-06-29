class TrialImporter
  def initialize(xml_file)
    @xml_file = xml_file
  end

  def import
    trial = Trial.new

    xml_mappings.each do |xml_mapping|
      value = root.xpath(xml_mapping.second).text
      trial.send("#{xml_mapping.first}=", value)
    end

    root.xpath("//location").each do |location|
      SiteImporter.new(trial: trial, site: location).import
    end

    trial.save
  end

  private

  attr_reader :xml_file

  def xml_mappings
    [
      [:title, "brief_title"],
      [:nct_id, "//nct_id"],
      [:description, "detailed_description/textblock"],
      [:sponsor, "sponsors/lead_sponsor/agency"]
    ]
  end

  def root
    @root ||= document.root
  end

  def document
    File.open(xml_file) { |f| Nokogiri::XML(f) }
  end
end
