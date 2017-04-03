require "rails_helper"

RSpec.describe "robots.txt" do
  context "when not blocking all web crawlers" do
    it "allows all crawlers" do
      with_environment "DISALLOW_ALL_WEB_CRAWLERS" => nil do
        get "/robots.txt"
      end

      expect(response.code).to eq "404"
    end
  end

  context "when blocking all web crawlers" do
    it "blocks all crawlers" do
      with_environment "DISALLOW_ALL_WEB_CRAWLERS" => "true" do
        get "/robots.txt"
      end

      expect(response).to render_template "disallow_all"
    end
  end
end
