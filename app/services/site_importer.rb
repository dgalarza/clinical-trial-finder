class SiteImporter
  def initialize(trial:, site:)
    @trial = trial
    @location_document = site
  end

  def import
    site = Site.new(trial: trial)

    xml_mappings.each do |xml_mapping|
      value = location_document.xpath(xml_mapping.second).text
      site.send("#{xml_mapping.first}=", value)
    end

    site.save
  end

  private

  attr_reader :location_document, :trial

  def xml_mappings
    [
      [:facility, "facility/name"],
      [:city, "facility/address/city"],
      [:state, "facility/address/state"],
      [:country, "facility/address/country"],
      [:zip_code, "facility/address/zip"],
      [:status, "status"],
      [:contact_name, "contact/last_name"],
      [:contact_phone, "contact/phone"],
      [:contact_phone_ext, "contact/phone_ext"],
      [:contact_email, "contact/email"]
    ]
  end
end
