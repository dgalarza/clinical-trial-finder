require "rails_helper"

RSpec.feature "User views trial list and trial" do
  before do
    create(:import_log)
  end

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
    first_trial_title = "First Trial"
    create(:trial, title: first_trial_title)
    second_trial_title = "Second Trial"
    create(:trial, title: second_trial_title)
    visit trials_path

    expect(page).to have_content first_trial_title
    expect(page).to have_content second_trial_title

    fill_form(:trial_search, keyword: "first")
    click_button t("trials.search_filter.submit")

    expect(page).to have_content first_trial_title
    expect(page).not_to have_content second_trial_title
  end

  scenario "User browses trials on second page of results" do
    trial_count = 15
    1.upto(trial_count) { |number| create(:trial, title: "Trial #{number}") }

    visit trials_path

    expect(page).to have_content "Displaying #{trial_count} trials"
    expect(page).not_to have_content "Trial #{trial_count}"

    click_link "Next"

    expect(page).to have_content "Trial #{trial_count}"
  end

  scenario "User filters by age" do
    trial_matches_age = create(
      :trial,
      minimum_age_original: "20 years",
      maximum_age_original: "35 years"
    )
    create(
      :trial,
      minimum_age_original: "36 months",
      maximum_age_original: "29 years"
    )
    create(
      :trial,
      minimum_age_original: "31 years",
      maximum_age_original: "N/A"
    )
    visit trials_path

    expect(page).to have_content "Displaying 3 trials"

    fill_form(:trial_search, age: 30)
    click_button t("trials.search_filter.submit")

    expect(page).to have_content "Displaying 1 trial"
    expect(page).to have_content trial_matches_age.title
  end
end
