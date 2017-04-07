require "rails_helper"

feature "admin configures filter" do
  scenario "sets filter for site" do
    create(:import_log)
    create(:trial)

    visit admin_root_url
    click_on "Configure Filters"

    fill_in "Condition filter", with: "brain tumor"
    click_on "Save Configuration"

    expect(page).to have_content "Filter updated successfully"
    expect(page).to have_field "Condition filter", with: "brain tumor"
  end
end
