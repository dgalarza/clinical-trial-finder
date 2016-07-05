require "rails_helper"

RSpec.describe Trial, type: :model do
  describe "Associations" do
    it { is_expected.to have_many(:sites) }
  end

  describe ".search_for" do
    it "queries by title and description" do
      trial_with_keyword = create(:trial, title: "the special word is present")
      description_with_keyword =
        create(:trial, description: "the special word is present")
      create(:trial, title: "not_searchable")

      trials = Trial.search_for("special")

      expect(trials).to eq [trial_with_keyword, description_with_keyword]
    end
  end
end
