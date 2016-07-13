require "rails_helper"

RSpec.feature "User views trial" do
  include TrialListHelpers

  before do
    create(:import_log)
  end

  scenario "User views trial list and trial w/ site" do
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

  scenario "User filters, views trial, and returns back to filtered list" do
    _non_filtered_trial = create(:trial)
    keyword = "special word"
    gender = "Female"
    filtered_trial = create(
      :trial,
      title: "This trial has a #{keyword}",
      healthy_volunteers: Trial::CONTROL_NEEDED,
      gender: gender
    )
    visit trials_path

    expect(page).to have_content displaying_multiple_trials(2)

    choose am_patient_field
    choose gender
    fill_in("trial_filter[keyword]", with: keyword)
    apply_search_filter

    expect(page).to have_content displaying_one_trial

    click_link filtered_trial.title
    click_link return_to_search

    expect(page).to have_content displaying_one_trial
    expect(find_field(am_patient_field)).to be_checked
    expect(find_field(gender)).to be_checked
    expect(page).to have_field("trial_filter[keyword]", with: keyword)
  end

  scenario "User filters and navigates thru filtered results" do
    gender = "Female"
    keyword = "special"
    age = "30"
    _non_filtered_trial = create(:trial)
    filtered_trial_1 = create(
      :trial,
      title: "Special trial 1",
      healthy_volunteers: Trial::CONTROL_NEEDED,
      gender: gender
    )
    filtered_trial_2 = create(
      :trial,
      title: "Special trial 2",
      healthy_volunteers: Trial::CONTROL_NEEDED,
      gender: gender
    )
    visit trials_path

    expect(page).to have_content displaying_multiple_trials(3)

    fill_in("trial_filter[age]", with: age)
    fill_in("trial_filter[keyword]", with: keyword)
    choose am_patient_field
    choose gender
    apply_search_filter

    expect(page).to have_content displaying_multiple_trials(2)

    click_link filtered_trial_1.title

    expect(page).to have_content filtered_trial_1.title
    expect(page).not_to have_content filtered_trial_2.title
    expect(page).not_to have_content previous_trial

    click_link next_trial

    expect(page).not_to have_content filtered_trial_1.title
    expect(page).to have_content filtered_trial_2.title
    expect(page).not_to have_content next_trial

    click_link previous_trial

    expect(page).to have_content filtered_trial_1.title
    expect(page).not_to have_content filtered_trial_2.title

    click_link return_to_search

    expect(page).to have_content displaying_multiple_trials(2)
    expect(find_field(am_patient_field)).to be_checked
    expect(find_field(gender)).to be_checked
    expect(page).to have_field("trial_filter[keyword]", with: keyword)
    expect(page).to have_field("trial_filter[age]", with: age)
  end

  def return_to_search
    t("trials.navigation.return_to_search")
  end

  def next_trial
    t("trials.navigation.next_trial")
  end

  def previous_trial
    t("trials.navigation.previous_trial")
  end
end
