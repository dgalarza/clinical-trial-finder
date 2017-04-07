require "rails_helper"

describe ConditionsQueryBuilder do
  describe ".transform" do
    it "transforms the given conditions for a URI" do
      query = ConditionsQueryBuilder.transform("brain tumor")

      expect(query).to eq "brain%20tumor"
    end

    it "joins multiple conditions properly" do
      query = ConditionsQueryBuilder.transform("brain tumor\r\nliver tumor")

      expect(query).to eq "brain%20tumor+OR+liver%20tumor"
    end
  end
end
