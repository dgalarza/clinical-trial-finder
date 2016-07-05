require "rails_helper"

RSpec.feature "User views trial list and trial" do
  scenario "User views trial list and trial" do
    trial_title = "Trial Title"
    trial_description = "Overview of trial"
    site_facility = "Site Facility"
    site_zip = "12345"
    import = create(:import_log)
    trial = create(:trial, title: trial_title, description: trial_description)
    create(:site, facility: site_facility, zip_code: site_zip, trial: trial)
    visit trials_path

    expect(page).to have_content l(import.created_at, format: :timestamp)

    click_link trial_title

    expect(page).to have_content trial_description
    expect(page).to have_content site_zip
  end

  scenario "User searches by keyword" do
    create(:import_log)
    first_trial_title = "First Trial"
    create(:trial, title: first_trial_title)
    second_trial_title = "Second Trial"
    create(:trial, title: second_trial_title)
    visit trials_path

    expect(page).to have_content first_trial_title
    expect(page).to have_content second_trial_title

    fill_form(
      :trial_search,
      keyword: "first"
    )
    click_button t("trials.search_filter.submit")

    expect(page).to have_content first_trial_title
    expect(page).not_to have_content second_trial_title
  end
end
