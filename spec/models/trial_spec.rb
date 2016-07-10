require "rails_helper"

RSpec.describe Trial, type: :model do
  describe "Associations" do
    it { is_expected.to have_many(:sites) }
  end

  describe "before_save" do
    describe "#convert_ages" do
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

    describe ".control" do
      context "control is true" do
        it "queries trials that only take healthy volunteers" do
          trial_for_controls_and_patients =
            create(:trial, healthy_volunteers: Trial::CONTROL_NEEDED)
          trial_without_setting =
            create(:trial, healthy_volunteers: Trial::CONTROL_NOT_SPECIFIED)
          _trial_for_patients_only = create(:trial, healthy_volunteers: "No")

          trials = Trial.control("true")

          expect(trials).to eq [
            trial_for_controls_and_patients,
            trial_without_setting
          ]
        end
      end

      context "control is false" do
        it "returns all trials" do
          trial_for_controls_and_patients =
            create(:trial, healthy_volunteers: Trial::CONTROL_NEEDED)
          trial_without_setting =
            create(:trial, healthy_volunteers: Trial::CONTROL_NOT_SPECIFIED)
          trial_for_patients_only = create(:trial, healthy_volunteers: "No")

          trials = Trial.control("false")

          expect(trials).to eq [
            trial_for_controls_and_patients,
            trial_without_setting,
            trial_for_patients_only
          ]
        end
      end

      context "control is NOT provided" do
        it "returns all trials" do
          trial_for_controls_and_patients =
            create(:trial, healthy_volunteers: Trial::CONTROL_NEEDED)
          trial_without_setting =
            create(:trial, healthy_volunteers: Trial::CONTROL_NOT_SPECIFIED)
          trial_for_patients_only = create(:trial, healthy_volunteers: "No")

          trials = Trial.control(nil)

          expect(trials).to eq [
            trial_for_controls_and_patients,
            trial_without_setting,
            trial_for_patients_only
          ]
        end
      end
    end

    describe ".close_to" do
      context "zip code is NOT provided" do
        it "returns all trials" do
          seed_new_york_zip_code
          new_york_site =
            build(:site, latitude: 40.7728432, longitude: -73.9558204)
          new_york_trial = create(:trial, sites: [new_york_site])
          san_fransicso_site =
            build(:site, latitude: 37.7642093, longitude: -122.4571623)
          san_francisco_trial = create(:trial, sites: [san_fransicso_site])

          trials = Trial.close_to("")

          expect(trials).to eq [
            new_york_trial,
            san_francisco_trial
          ]
        end
      end

      context "zip code is provided" do
        it "returns trials w/ sites inside radius ordered by distance" do
          seed_new_york_zip_code
          newark_site = build(
            :site,
            facility: "Newark Site",
            latitude: 40.7132136,
            longitude: -75.7496572
          )
          newark_trial = create(:trial, sites: [newark_site])
          new_york_site = build(
            :site,
            facility: "New York Site",
            latitude:
            40.7728432,
            longitude: -73.9558204
          )
          new_york_trial = create(:trial, sites: [new_york_site])
          san_fransicso_site =
            build(:site, latitude: 37.7642093, longitude: -122.4571623)
          _san_francisco_trial = create(:trial, sites: [san_fransicso_site])

          trials = Trial.close_to(new_york_zip_code)

          expect(trials).to eq [
            new_york_trial,
            newark_trial
          ]
        end
      end
    end
  end

  describe "#closest_site" do
    it "returns collection of closest site to zip code with distance" do
      seed_new_york_zip_code
      zip_code = "10065"
      different_trial = create(:trial)
      _closest_site_belonging_to_different_trial = create(
        :site,
        latitude: 40.7728432,
        longitude: -73.9558204,
        trial: different_trial
      )
      trial = create(:trial)
      closest_site_for_trial = create(
        :site,
        latitude: 40.7132136,
        longitude: -75.7496572,
        trial: trial
      )
      _further_site_for_trial = create(
        :site,
        latitude: 37.7642093,
        longitude: -122.4571623,
        trial: trial
      )

      closest_site = trial.closest_site(zip_code)

      expect(closest_site).to eq [closest_site_for_trial, 94]
    end
  end

  def seed_new_york_zip_code
    ZipCode.create(
      zip_code: new_york_zip_code,
      latitude: 40.7728432,
      longitude: -73.9558204
    )
  end

  def new_york_zip_code
    "10065"
  end
end
