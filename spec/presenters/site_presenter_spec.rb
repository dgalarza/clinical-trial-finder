require "rails_helper"

RSpec.describe SitePresenter do
  context "there is no phone number, email or name" do
    it "returns false" do
      site = build(
        :site,
        contact_phone: nil,
        contact_email: nil,
        contact_name: nil,
      )
      presenter = SitePresenter.new(site)

      expect(presenter.contact_displayable?).to be false
    end
  end

  context "there is a phone number" do
    it "returns true" do
      site = build(
        :site,
        contact_phone: "3456789012",
        contact_email: nil,
        contact_name: nil,
      )
      presenter = SitePresenter.new(site)

      expect(presenter.contact_displayable?).to be true
    end
  end

  context "there is an email" do
    it "returns true" do
      site = build(
        :site,
        contact_phone: nil,
        contact_email: "test@gmail.com",
        contact_name: nil,
      )
      presenter = SitePresenter.new(site)

      expect(presenter.contact_displayable?).to be true
    end
  end

  context "there is a contact name" do
    it "returns true" do
      site = build(
        :site,
        contact_phone: nil,
        contact_email: nil,
        contact_name: "Test User",
      )
      presenter = SitePresenter.new(site)

      expect(presenter.contact_displayable?).to be true
    end
  end

  describe "#phone_to_call" do
    context "extension exists" do
      it "returns phone , extension" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: "5076",
        )
        presenter = SitePresenter.new(site)

        expect(presenter.phone_to_call).to eq "2345678901,5076"
      end
    end

    context "extension does NOT exist" do
      it "returns phone" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: "",
        )
        presenter = SitePresenter.new(site)

        expect(presenter.phone_to_call).to eq "2345678901"
      end
    end
  end

  describe "#phone_as_text" do
    context "extension exists" do
      it "returns phone , extension" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: "5076",
        )
        presenter = SitePresenter.new(site)

        expect(presenter.phone_as_text).to eq "2345678901 #5076"
      end
    end

    context "extension does NOT exist" do
      it "returns phone" do
        site = build(
          :site,
          contact_phone: "2345678901",
          contact_phone_ext: "",
        )
        presenter = SitePresenter.new(site)

        expect(presenter.phone_as_text).to eq "2345678901"
      end
    end
  end
end
