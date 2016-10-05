require "rails_helper"

RSpec.describe TrialPageHelper, type: :helper do
  describe "show_nearest_site?" do
    context "session zip_code_coordinates are set" do
      before do
        session[:zip_code_coordinates] = ["123", "456"]
      end

      context "site count is NOT 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 5)

          expect(helper_response).to be true
        end
      end

      context "site count is 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 1)

          expect(helper_response).to be true
        end
      end
    end

    context "session zip_code_coordinates are NOT set" do
      context "site count is NOT 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 5)

          expect(helper_response).to be false
        end
      end

      context "site count is 1" do
        it "returns true" do
          helper_response = show_nearest_site?(count: 1)

          expect(helper_response).to be true
        end
      end
    end
  end
end
