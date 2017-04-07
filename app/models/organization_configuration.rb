class OrganizationConfiguration < ActiveRecord::Base
  def self.get
    OrganizationConfiguration.first_or_create
  end
end
