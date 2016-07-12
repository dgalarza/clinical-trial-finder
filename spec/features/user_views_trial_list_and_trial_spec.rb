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

  scenario "User filters by zip code" do
    seed_new_york_zip_code
    new_york_site = build(:site, latitude: 40.7728432, longitude: -73.9558204)
    new_york_trial = create(:trial, sites: [new_york_site])
    newark_site = build(:site, latitude: 40.7132136, longitude: -75.7496572)
    newark_trial = create(:trial, sites: [newark_site])
    san_fransicso_site =
      build(:site, latitude: 37.7642093, longitude: -122.4571623)
    san_francisco_trial = create(:trial, sites: [san_fransicso_site])
    visit trials_path

    expect(page).to have_content displaying_multiple_trials(3)
    expect(page).not_to have_content new_york_site.facility
    expect(page).not_to have_content newark_site.facility

    fill_in("trial_filter[zip_code]", with: new_york_zip_code)
    apply_search_filter

    expect(page).to have_content displaying_multiple_trials(2)

    expect(page).to have_content new_york_trial.title
    expect(page).to have_content new_york_site.facility
    expect(page).to have_content miles_away(0)

    expect(page).to have_content newark_trial.title
    expect(page).to have_content newark_site.facility
    expect(page).to have_content miles_away(94)

    expect(page).not_to have_content san_francisco_trial.title

    select distance_radius(50)
    apply_search_filter

    expect(page).to have_select(
      "trial_filter[distance_radius]",
      selected: distance_radius(50)
    )
    expect(page).to have_content displaying_one_trial

    expect(page).to have_content new_york_trial.title
    expect(page).to have_content new_york_site.facility
    expect(page).to have_content miles_away(0)

    expect(page).not_to have_content newark_trial.title
    expect(page).not_to have_content newark_site.facility
    expect(page).not_to have_content miles_away(94)

    expect(page).not_to have_content san_francisco_trial.title
  end

  def distance_radius(radius)
    t("helpers.search_filter.distance_radius", radius: radius)
  end

  def miles_away(count)
    t("trials.closest_site.miles_away", count: count)
  end

  def seed_new_york_zip_code
    ZipCode.create(
      zip_code: new_york_zip_code,
      latitude: 40.7728432,
      longitude: -73.9558204
    )
  end

  def new_york_zip_code
    "10065"
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
