require "rails_helper"

RSpec.describe SiteDistanceCalculator do
  before do
    seed_newark_zip_code
  end

  describe "nearby_trials" do
    context "zip code is not present" do
      it "returns trials ordered by title" do
        new_york_site =
          build(:site, latitude: 40.7728432, longitude: -73.9558204)
        new_york_trial =
          create(:trial, title: "B Trial", sites: [new_york_site])
        newark_site = build(:site, latitude: 40.7132136, longitude: -75.7496572)
        newark_trial = create(:trial, title: "C Trial", sites: [newark_site])
        san_fransicso_site =
          build(:site, latitude: 37.7642093, longitude: -122.4571623)
        san_francisco_trial =
          create(:trial, title: "A Trial", sites: [san_fransicso_site])

        trials = SiteDistanceCalculator.new(zip_code: nil).nearby_trials(Trial)

        expect(trials).to eq [san_francisco_trial, new_york_trial, newark_trial]
      end
    end

    context "zip code is present" do
      it "returns trials within radius ordered by distance" do
        new_york_site =
          build(:site, latitude: 40.7728432, longitude: -73.9558204)
        new_york_trial =
          create(:trial, title: "New York", sites: [new_york_site])
        newark_site = build(:site, latitude: 40.7132136, longitude: -75.7496572)
        newark_trial = create(:trial, title: "Newark", sites: [newark_site])
        san_fransicso_site =
          build(:site, latitude: 37.7642093, longitude: -122.4571623)
        _san_francisco_trial =
          create(:trial, title: "San Francisco", sites: [san_fransicso_site])

        trials = SiteDistanceCalculator.new(zip_code: newark_zip_code).
          nearby_trials(Trial)

        expect(trials).to eq [newark_trial, new_york_trial]
      end
    end
  end

  describe "#closest_site" do
    context "zip code is present" do
      it "returns closest site and distance" do
        new_york_site =
          build(:site, latitude: 40.7728432, longitude: -73.9558204)
        newark_site = build(:site, latitude: 40.7132136, longitude: -75.7496572)
        trial =
          create(:trial, sites: [newark_site, new_york_site])

        closest = SiteDistanceCalculator.new(zip_code: newark_zip_code).
          closest_site(trial.sites)

        expect(closest).to eq [newark_site, 0]
      end
    end

    context "site is not present within zip code radius" do
      it "returns nil" do
        san_fransicso_site =
          build(:site, latitude: 37.7642093, longitude: -122.4571623)
        trial = create(:trial, sites: [san_fransicso_site])
        closest = SiteDistanceCalculator.new(zip_code: newark_zip_code).
          closest_site(trial.sites)

        expect(closest).to be_nil
      end
    end

    context "zip code is not present" do
      it "returns nil" do
        trial = create(:trial)
        closest = SiteDistanceCalculator.new(zip_code: nil).
          closest_site(trial.sites)

        expect(closest).to be_nil
      end
    end
  end

  def seed_newark_zip_code
    ZipCode.create(
      zip_code: newark_zip_code,
      latitude: 40.7132136,
      longitude: -75.7496572
    )
  end

  def newark_zip_code
    "07101"
  end
end
