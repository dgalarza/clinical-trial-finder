require "rails_helper"

RSpec.describe TrialPresenter do
  before do
    define_description_list_items
  end

  describe "#to_s" do
    it "returns trial title" do
      title = "Trial title"
      trial = build(:trial, title: title)

      trial_presenter = TrialPresenter.new(trial)

      expect(trial_presenter.to_s). to eq title
    end
  end

  describe "description_as_markup" do
    it "identifies list item content and wraps <li>" do
      trial = build(:trial, description: original_text)

      trial_presenter = TrialPresenter.new(trial)

      expect(trial_presenter.description_as_markup).to eq expected_text
    end
  end

  describe "detailed_description_as_markup" do
    it "identifies list item content and wraps <li>" do
      trial = build(:trial, detailed_description: original_text)

      trial_presenter = TrialPresenter.new(trial)

      expect(trial_presenter.detailed_description_as_markup).to eq expected_text
    end
  end

  describe "criteria_as_markup" do
    it "identifies list item content and wraps <li>" do
      trial = build(:trial, criteria: original_text)

      trial_presenter = TrialPresenter.new(trial)

      expect(trial_presenter.criteria_as_markup).to eq expected_text
    end

    it "wraps inclusion/exclusion with header tag" do
      trial = build(:trial, criteria: original_criteria)

      trial_presenter = TrialPresenter.new(trial)

      expect(trial_presenter.criteria_as_markup).to eq expected_criteria
    end
  end

  describe "#age_range" do
    context "max age is valid age" do
      it "returns min and max age" do
        trial = build(
          :trial,
          minimum_age_original: "15 years",
          maximum_age_original: "60 years"
        )

        trial_presenter = TrialPresenter.new(trial)

        expect(trial_presenter.age_range).to eq "15 years - 60 years"
      end
    end

    context "max age is 'N/A'" do
      it "returns min and max age" do
        trial = build(
          :trial,
          minimum_age_original: "15 years",
          maximum_age_original: "N/A"
        )

        trial_presenter = TrialPresenter.new(trial)

        expect(trial_presenter.age_range).to eq "15 years and Over"
      end
    end
  end

  def original_criteria
    <<-DESCRIPTION
      Inclusion Criteria:
      Item 1
      Exclusion Criteria:
      Item 1
    DESCRIPTION
  end

  def expected_criteria
    <<-DESCRIPTION
      <h2>Inclusion Criteria:</h2>
      Item 1
      <h2>Exclusion Criteria:</h2>
      Item 1
    DESCRIPTION
  end

  def original_text
    <<-DESCRIPTION
      Primary Objectives:
      - #{list_1} - #{list_2} Inbetween text.
      (1) #{list_3} (2) #{list_4} Inbetween text.
      I. #{list_5} II. #{list_6} III. #{list_7} IV. #{list_8} V. #{list_9} VI. #{list_10} VII. #{list_11} VIII. #{list_12} IX. #{list_13} X. #{list_14} Inbetween text.
    DESCRIPTION
  end

  def expected_text
    <<-DESCRIPTION
      Primary Objectives:
     <ul><li>#{list_1}</li></ul><ul><li>#{list_2}</li></ul>Inbetween text.
     <ul><li>#{list_3}</li></ul><ul><li>#{list_4}</li></ul>Inbetween text.
     <ul><li>#{list_5}</li></ul><ul><li>#{list_6}</li></ul><ul><li>#{list_7}</li></ul><ul><li>#{list_8}</li></ul><ul><li>#{list_9}</li></ul><ul><li>#{list_10}</li></ul><ul><li>#{list_11}</li></ul><ul><li>#{list_12}</li></ul><ul><li>#{list_13}</li></ul><ul><li>#{list_14}</li></ul>Inbetween text.
    DESCRIPTION
  end

  def define_description_list_items
    1.upto(14).map do |number|
      self.class.send(
        :define_method,
        "list_#{number}",
        proc { "List Item Number #{number}." }
      )
    end
  end

  def expect_description_list_items_as_list(list_items)
    list_items.each do |list|
      expect(page).to have_css "li", text: send(list)
    end
  end
end
