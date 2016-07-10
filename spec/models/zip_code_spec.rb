require "rails_helper"

RSpec.describe ZipCode, type: :model do
  describe "#coordinates" do
    it "returns an array of latitude, longitude" do
      latitude = 12.345
      longitude = 67.890
      zip_code = ZipCode.new(latitude: latitude, longitude: longitude)

      expect(zip_code.coordinates).to eq [latitude, longitude]
    end
  end
end
