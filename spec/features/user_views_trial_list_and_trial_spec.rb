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

    fill_in("trial_filter[keyword]", with: "first")
    apply_search_filter

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

    fill_in("trial_filter[age]", with: "30")
    apply_search_filter

    expect(page).to have_content displaying_one_trial
    expect(page).to have_content trial_matches_age.title
  end

  scenario "User filters by gender" do
    trial_for_everyone = create(:trial, gender: "Both")
    trial_for_men = create(:trial, gender: "Male")
    trial_for_women = create(:trial, gender: "Female")
    visit trials_path

    expect(page).to have_content displaying_multiple_trials(3)

    choose "Female"
    apply_search_filter

    expect(find_field("Female")).to be_checked
    expect(page).to have_content displaying_multiple_trials(2)
    expect(page).to have_content trial_for_everyone.title
    expect(page).to have_content trial_for_women.title
    expect(page).not_to have_content trial_for_men.title

    choose "Male"
    apply_search_filter

    expect(find_field("Male")).to be_checked
    expect(page).to have_content displaying_multiple_trials(2)
    expect(page).to have_content trial_for_everyone.title
    expect(page).not_to have_content trial_for_women.title
    expect(page).to have_content trial_for_men.title
  end

  scenario "User filters by control" do
    trial_for_controls_and_patients =
      create(:trial, healthy_volunteers: Trial::CONTROL_NEEDED)
    trial_without_setting =
      create(:trial, healthy_volunteers: Trial::CONTROL_NOT_SPECIFIED)
    trial_for_patients_only = create(:trial, healthy_volunteers: "No")
    visit trials_path

    expect(page).to have_content displaying_multiple_trials(3)

    choose am_control_field
    apply_search_filter

    expect(find_field(am_control_field)).to be_checked
    expect(page).to have_content displaying_multiple_trials(2)
    expect(page).to have_content trial_for_controls_and_patients.title
    expect(page).to have_content trial_without_setting.title
    expect(page).not_to have_content trial_for_patients_only.title

    choose am_patient_field
    apply_search_filter

    expect(find_field(am_patient_field)).to be_checked
    expect(page).to have_content displaying_multiple_trials(3)
    expect(page).to have_content trial_for_controls_and_patients.title
    expect(page).to have_content trial_without_setting.title
    expect(page).to have_content trial_for_patients_only.title
  end

  def apply_search_filter
    click_button t("trials.search_filter.submit")
  end

  def am_control_field
    t("helpers.search_filter.am_control")
  end

  def am_patient_field
    t("helpers.search_filter.am_patient")
  end

  def displaying_one_trial
    t("trials.trial_count.displaying.one")
  end

  def displaying_multiple_trials(count)
    t("trials.trial_count.displaying.other", count: count)
  end
end
