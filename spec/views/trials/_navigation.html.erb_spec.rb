require "rails_helper"

RSpec.describe "trials/_navigation", type: :view do
  before do
    assign(:trial, build(:trial))
    allow(view).to receive(:previous_trial_link)
    allow(view).to receive(:next_trial_link)
  end

  context "patient navigates to trial from search" do
    it "displays search result links" do
      session[:search_results] = [1, 2, 3]

      render

      expect(page).to have_css search_result_links
    end
  end

  context "patient navigates to trial directly without search" do
    it "displays search result links" do
      session[:search_results] = nil

      render

      expect(page).not_to have_css search_result_links
    end
  end

  def search_result_links
    ".search-result-links"
  end
end
