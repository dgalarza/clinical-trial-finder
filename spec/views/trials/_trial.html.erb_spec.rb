require "rails_helper"

RSpec.describe "trials/_trial", type: :view do
  before do
    allow(view).to receive(:render).and_call_original
    stub_closest_site_template
  end

  context "NOT filtered by zip code" do
    it "does NOT render closest site" do
      allow(view).to receive(:zip_code_param).and_return(nil)
      site = double(:site)
      trial = double(:trial, closest_site: site).as_null_object

      render "trials/trial", trial: trial

      expect(trial).not_to have_received(:closest_site)
      expect(view).not_to have_received(:render).with(
        "closest_site",
        closest_site: site
      )
    end
  end

  context "filtered by zip code" do
    it "renders closest site template" do
      zip_code = "12345"
      allow(view).to receive(:zip_code_param).and_return(zip_code)
      site = double(:site)
      trial = double(:trial, closest_site: site).as_null_object

      render "trials/trial", trial: trial

      expect(view).to have_received(:render).with(
        "closest_site",
        closest_site: site
      )
    end
  end

  def stub_closest_site_template
    stub_template("trials/_closest_site.html.erb" => "")
  end
end
