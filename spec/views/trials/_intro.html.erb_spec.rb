require "rails_helper"

RSpec.describe "trials/_intro" do
  context "show_intro? is true" do
    it "shows intro" do
      allow(view).to receive(:show_intro?).and_return(true)

      render

      expect(page).to have_css(".intro-text")
    end
  end

  context "show_intro? is false" do
    it "does not show intro" do
      allow(view).to receive(:show_intro?).and_return(false)

      render

      expect(page).not_to have_css(".intro-text")
    end
  end
end
