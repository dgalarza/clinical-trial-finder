require "rails_helper"

RSpec.describe Trial, type: :model do
  describe "Associations" do
    it { is_expected.to have_many(:sites) }
  end

  describe "before_save" do
    it "persists original values as stripped integers" do
      trial = build(
        :trial,
        minimum_age_original: "20 Years",
        maximum_age_original: "30 Years"
      )

      trial.save

      expect(trial.minimum_age).to eq 20
      expect(trial.maximum_age).to eq 30
    end

    context "age is NOT applicable" do
      it "use age defaults" do
        trial = build(
          :trial,
          minimum_age_original: "N/A",
          maximum_age_original: "N/A"
        )

        trial.save

        expect(trial.minimum_age).to eq Trial::MINIMUM_AGE
        expect(trial.maximum_age).to eq Trial::MAXIMUM_AGE
      end
    end

    context "age is in month increments" do
      it "transforms months to years" do
        trial = build(
          :trial,
          minimum_age_original: "1 Month",
          maximum_age_original: "18 Months"
        )

        trial.save

        expect(trial.minimum_age).to eq 0
        expect(trial.maximum_age).to eq 1
      end
    end
  end

  context "scopes" do
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

    describe ".age" do
      it "queries patient age between minimum and maximum" do
        trial_matches_age = create(
          :trial,
          minimum_age_original: "25 years",
          maximum_age_original: "35 years"
        )
        create(
          :trial,
          minimum_age_original: "20 years",
          maximum_age_original: "29 years"
        )
        create(
          :trial,
          minimum_age_original: "31 years",
          maximum_age_original: "35 years"
        )

        trials = Trial.age(30)

        expect(trials).to eq [trial_matches_age]
      end
    end
  end
end
