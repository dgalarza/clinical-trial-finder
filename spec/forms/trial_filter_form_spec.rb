require "rails_helper"

RSpec.describe TrialFilterForm, type: :model do
  describe "validations" do
    it { is_expected.to allow_value(23456).for(:zip_code) }
    it { is_expected.to allow_value(23456-3456).for(:zip_code) }
    it { is_expected.not_to allow_value(2346).for(:zip_code) }
    it { is_expected.not_to allow_value(invalid_zip).for(:zip_code) }

    it do
      is_expected.to validate_numericality_of(:age).
        only_integer.is_greater_than_or_equal_to(1).
        is_less_than_or_equal_to(120).allow_nil
    end
  end

  describe "#new" do
    context "initialized with some valid filters" do
      it "fires FilterApplied event" do
        _matching_trial = create(:trial, title: "Glioma Trial")
        _non_matching_trial = create(:trial, title: "Non matching trial")
        session_id = double(:session_id)
        set_params = {
          "age" => "",
          "control" => "",
          "distance_radius" => "100",
          "gender" => "",
          "keyword" => "Glioma",
          "session_id" => session_id,
          "study_type" => "",
          "zip_code" => "",
        }

        TrialFilterForm.new(set_params)

        expect(last_event[:event]).to eq TrialFilterForm::FILTER_APPLIED_EVENT
        expect(last_event[:anonymous_id]).to eq session_id
        expect(last_event[:properties]).to eq(
          distance_radius: 100,
          keyword: "glioma",
          match_count: 1,
        )
      end
    end

    context "initialized with all valid filters" do
      it "fires FilterApplied event" do
        _non_matching_trial = create(:trial)
        session_id = double(:session_id)
        set_params = {
          "age" => "15",
          "control" => "true",
          "distance_radius" => "100",
          "gender" => "Male",
          "keyword" => "Glioma",
          "session_id" => session_id,
          "study_type" => "Observational",
          "zip_code" => "07030",
        }

        TrialFilterForm.new(set_params)

        expect(last_event[:event]).to eq TrialFilterForm::FILTER_APPLIED_EVENT
        expect(last_event[:anonymous_id]).to eq session_id
        expect(last_event[:properties]).to eq(
          age: 15,
          control_only: "true",
          distance_radius: 100,
          gender: "Male",
          keyword: "glioma",
          match_count: 0,
          study_type: "Observational",
          zip_code: "07030",
        )
      end
    end

    context "initialized with no filters" do
      it "does not fire an event" do
        TrialFilterForm.new("session_id" => 12345).trials

        expect(analytics.events.last).not_to be_present
      end
    end

    context "initialized with empty filters" do
      it "fires EmptyFilterApplied event" do
        session_id = double(:session_id)
        unset_params = {
          "age" => "",
          "distance_radius" => "100",
          "keyword" => "",
          "zip_code" => "",
          "session_id" => session_id,
        }
        TrialFilterForm.new(unset_params).trials

        expect(last_event[:event]).
          to eq TrialFilterForm::EMPTY_FILTER_APPLIED_EVENT
        expect(last_event[:anonymous_id]).to eq session_id
      end
    end
  end

  describe "#trials" do
    context "form is valid" do
      it "queries for trials" do
        trial = create(:trial)

        trials = TrialFilterForm.new.trials

        expect(trials).to eq [trial]
      end
    end

    context "form is NOT valid" do
      it "returns no trials" do
        create(:trial)

        trials = TrialFilterForm.new(zip_code: invalid_zip).trials

        expect(trials).to eq []
      end
    end
  end

  describe "#trial_ids" do
    it "returns ids of all matching trials" do
      trial = create(:trial)

      trials = TrialFilterForm.new.trial_ids

      expect(trials).to eq [trial.id]
    end
  end

  def invalid_zip
    "abcdef"
  end

  def last_event
    analytics.events.last.first
  end
end
