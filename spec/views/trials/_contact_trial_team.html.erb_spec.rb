require "rails_helper"

RSpec.describe "trials/contact_trial_team", type: :view do
  before do
    allow(view).to receive(:united_states_sites).and_return([])
  end

  context "sites outside of the United States are present" do
    it "displays international sites header" do
      trial = create(:trial)

      allow(view).to receive(:non_united_states_sites).with(trial).
        and_return(trial.sites)

      render "trials/contact_trial_team", trial: trial

      expect(page).to have_content international_site_text
    end
  end

  context "sites outside of the United States are present" do
    it "displays international sites header" do
      trial = build(:trial)

      allow(view).to receive(:non_united_states_sites).with(trial).
        and_return([])

      render "trials/contact_trial_team", trial: trial

      expect(page).not_to have_content international_site_text
    end
  end

  def international_site_text
    t("trials.contact_trial_team.international_sites")
  end
end
