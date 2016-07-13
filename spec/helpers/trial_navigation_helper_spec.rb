require "rails_helper"

RSpec.describe TrialNavigationHelper, type: :helper do
  describe "#previous_trial_link" do
    context "provided trial is first in search results" do
      it "returns nil" do
        trial_id = 1
        session[:search_results] = [trial_id, 2, 3]

        link = helper.previous_trial_link(trial_id)

        expect(link).to eq nil
      end
    end

    context "provided trial is NOT first in search results" do
      it "returns link to previous trial" do
        previous_trial_id = 1
        trial_id = 2
        session[:search_results] = [previous_trial_id, trial_id, 3]

        link = helper.previous_trial_link(trial_id)

        expect(link).to eq link_to(
          t("trials.navigation.previous_trial"),
          trial_path(previous_trial_id)
        )
      end
    end
  end

  describe "#next_trial_link" do
    context "provided trial is last in search results" do
      it "returns nil" do
        trial_id = 3
        session[:search_results] = [1, 2, trial_id]

        link = helper.next_trial_link(trial_id)

        expect(link).to eq nil
      end
    end

    context "provided trial is NOT last in search results" do
      it "returns link to next trial" do
        next_trial_id = 3
        trial_id = 2
        session[:search_results] = [1, trial_id, next_trial_id]

        link = helper.next_trial_link(trial_id)

        expect(link).to eq link_to(
          t("trials.navigation.next_trial"),
          trial_path(next_trial_id)
        )
      end
    end
  end
end
