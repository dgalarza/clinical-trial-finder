require 'rails_helper'

RSpec.describe OrganizationConfiguration, type: :model do
  describe ".get" do
    context "configuration does not exist" do
      it "creates a new configuration and returns it" do
        configuration = OrganizationConfiguration.get

        expect(configuration).to be_persisted
      end
    end

    context "configuration already exists" do
      it "returns the existing configuration" do
        existing_configuration = create(:organization_configuration)

        expect(OrganizationConfiguration.get).to eq existing_configuration
      end
    end
  end
end
