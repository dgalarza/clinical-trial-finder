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

    describe ".gender" do
      context "gender is filtered by male" do
        it "returns male and both" do
          trial_for_everyone = create(:trial, gender: "Both")
          trial_for_men = create(:trial, gender: "Male")
          _trial_for_women = create(:trial, gender: "Female")

          trials = Trial.gender("Male")

          expect(trials).to eq [trial_for_everyone, trial_for_men]
        end
      end

      context "gender is filtered by female" do
        it "returns female and both" do
          trial_for_everyone = create(:trial, gender: "Both")
          trial_for_women = create(:trial, gender: "Female")
          _trial_for_men = create(:trial, gender: "Male")

          trials = Trial.gender("Female")

          expect(trials).to eq [trial_for_everyone, trial_for_women]
        end
      end

      context "gender is NOT filtered" do
        it "does NOT filter" do
          trial_1 = create(:trial)
          trial_2 = create(:trial)

          trials = Trial.gender(nil)

          expect(trials).to eq [trial_1, trial_2]
        end
      end
    end

    describe ".age" do
      context "age is present" do
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

      context "age is NOT present" do
        it "does NOT filter" do
          trial_1 = create(:trial)
          trial_2 = create(:trial)

          trials = Trial.age(nil)

          expect(trials).to eq [trial_1, trial_2]
        end
      end
    end
  end
end
