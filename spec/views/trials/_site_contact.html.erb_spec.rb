require "rails_helper"

RSpec.describe "trials/site_contact" do
  context "contact is displayable" do
    it "displays contact" do
      site = SitePresenter.new(build(:site))
      allow(site).to receive(:contact_displayable?).and_return(true)

      render "trials/site_contact", site: site

      expect(page).to have_content t("trials.site_contact.site_contact")
    end
  end

  context "contact is NOT displayable" do
    it "does NOT display contact" do
      site = SitePresenter.new(build(:site))
      allow(site).to receive(:contact_displayable?).and_return(false)

      render "trials/site_contact", site: site

      expect(page).not_to have_content t("trials.site_contact.site_contact")
    end
  end
end
