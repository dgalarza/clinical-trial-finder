require "rails_helper"

RSpec.describe "trials/_trial_sidebar", type: :view do
  context "show_nearest_site? is false" do
    it "does NOT show nearest site" do
      trial = build(:trial)
      allow(view).to receive(:show_nearest_site?).
        with(count: trial.sites.count).and_return(false)

      render "trials/trial_sidebar", trial: trial

      expect(page).not_to have_css "iframe"
    end
  end

  context "show_nearest_site? is true" do
    it "does show nearest site" do
      trial = build(:trial)
      allow(trial).to receive(:ordered_sites).and_return(trial.sites)
      allow(view).to receive(:show_nearest_site?).
        with(count: trial.sites.count).and_return(true)

      render "trials/trial_sidebar", trial: trial

      expect(page).to have_css "iframe"
    end
  end
end
