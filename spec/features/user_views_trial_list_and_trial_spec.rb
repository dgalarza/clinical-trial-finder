require "rails_helper"

RSpec.feature "User views trial list and trial" do
  scenario "User views trial list and trial" do
    trial_title = "Trial Title"
    trial_description = "Overview of trial"
    site_facility = "Site Facility"
    site_zip = "12345"
    trial = create(:trial, title: trial_title, description: trial_description)
    create(:site, facility: site_facility, zip_code: site_zip, trial: trial)
    visit trials_path

    click_link trial_title

    expect(page).to have_content trial_description
    expect(page).to have_content site_zip
  end
end
