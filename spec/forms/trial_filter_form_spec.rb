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
end
