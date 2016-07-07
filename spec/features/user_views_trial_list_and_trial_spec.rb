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
    last_trial_title = Trial.last.title

    visit trials_path

    expect(page).to have_content displaying_multiple_trials(trial_count)
    expect(page).not_to have_content last_trial_title

    click_link "Next"

    expect(page).to have_content last_trial_title
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

    expect(page).to have_content displaying_multiple_trials(3)

    fill_form(:trial_search, age: 30)
    click_button t("trials.search_filter.submit")

    expect(page).to have_content displaying_one_trial
    expect(page).to have_content trial_matches_age.title
  end

  scenario "User filters by gender" do
    trial_for_everyone = create(:trial, gender: "Both")
    trial_for_men = create(:trial, gender: "Male")
    trial_for_women = create(:trial, gender: "Female")
    visit trials_path

    expect(page).to have_content displaying_multiple_trials(3)

    fill_form(:trial_search, gender: "Female")
    click_button t("trials.search_filter.submit")

    expect(page).to have_content displaying_multiple_trials(2)
    expect(page).to have_content trial_for_everyone.title
    expect(page).to have_content trial_for_women.title
    expect(page).not_to have_content trial_for_men.title

    fill_form(:trial_search, gender: "Male")
    click_button t("trials.search_filter.submit")

    expect(page).to have_content displaying_multiple_trials(2)
    expect(page).to have_content trial_for_everyone.title
    expect(page).not_to have_content trial_for_women.title
    expect(page).to have_content trial_for_men.title
  end

  def displaying_one_trial
    t("trials.trial_count.displaying.one")
  end

  def displaying_multiple_trials(count)
    t("trials.trial_count.displaying.other", count: count)
  end
end
