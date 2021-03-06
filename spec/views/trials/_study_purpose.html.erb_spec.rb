require "rails_helper"

RSpec.describe "trials/_study_purpose", type: :view do
  context "description is present" do
    it "displays study purpose" do
      trial = double(:trial, description_as_markup: true)

      render "trials/study_purpose", trial: trial

      expect(page).to have_content t("trials.study_purpose.study_purpose")
    end
  end

  context "description is NOT present" do
    it "does NOT display study purpose" do
      trial = double(:trial, description_as_markup: "")

      render "trials/study_purpose", trial: trial

      expect(page).not_to have_content t("trials.study_purpose.study_purpose")
    end
  end
end
