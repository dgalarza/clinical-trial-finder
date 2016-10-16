require "rails_helper"

RSpec.describe TrialPresenter do
  before do
    define_description_list_items
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
    <ul><li>#{list_1}</li><li>#{list_2}</li></ul>Inbetween text.
    <ul><li>#{list_3}</li><li>#{list_4}</li></ul>Inbetween text.
    <ul><li>#{list_5}</li><li>#{list_6}</li><li>#{list_7}</li><li>#{list_8}</li><li>#{list_9}</li><li>#{list_10}</li><li>#{list_11}</li><li>#{list_12}</li><li>#{list_13}</li><li>#{list_14}</li></ul>Inbetween text.
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
