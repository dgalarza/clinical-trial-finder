require "rails_helper"

RSpec.feature "User views trial" do
  include TrialListHelpers

  before do
    create(:import_log)
  end

  scenario "User views trial list and trial w/ site" do
    with_environment "GOOGLE_EMBED_KEY" => "ABC123" do
      trial_title = "Trial Title"
      trial_description = "Overview of trial"
      site_facility = "Site Facility"
      site = build(:site, facility: site_facility)
      create(:trial, title: trial_title, description: trial_description, sites: [site])
      visit trials_path

      click_link trial_title

      within ".trial-results" do
        expect(page).to have_content trial_description
        expect(page).to have_content site_facility
      end
      within ".trial-sidebar" do
        expect(page).to have_css google_map_for_site(site)
      end
    end
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

  def google_map_for_site(site)
    "iframe[src='https://www.google.com/maps/embed/v1/place?key=#{ENV.fetch("GOOGLE_EMBED_KEY")}&q=#{site.facility_address}']"
  end
end
