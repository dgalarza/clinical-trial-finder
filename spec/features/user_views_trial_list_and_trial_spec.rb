require "rails_helper"

RSpec.feature "User views trial list and trial" do
  scenario "User views trial list and trial" do
    trial_title = "Trial Title"
    trial_description = "Overview of trial"
    site_facility = "Site Facility"
    site_address = "100 Main St"
    site = create(:site, facility: site_facility, street_address: site_address)
    create(
      :trial,
      title: trial_title,
      description: trial_description,
      sites: [site]
    )
    visit trials_path

    click_link trial_title

    expect(page).to have_content trial_description
    expect(page).to have_content site_address
  end
end
