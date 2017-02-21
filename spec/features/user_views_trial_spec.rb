require "rails_helper"

RSpec.feature "User views trial" do
  include TrialListHelpers

  scenario "User views trial list and trial w/ site" do
    url = "http://resource-site.com"
    stub_resource_link_request(url)
    environment = {
      "GOOGLE_EMBED_KEY" => "ABC123",
      "RESOURCE_LIST_URL" => url,
    }
    with_environment environment do
      trial_title = "Trial Title"
      trial_description = "Trial Description"
      site_facility = "Site Facility"
      site = build(:site, facility: site_facility)
      create(
        :trial,
        title: trial_title,
        description: trial_description,
        sites: [site]
      )
      visit trials_path

      click_link trial_title

      within ".trial-page" do
        expect(page).to have_content trial_description
        expect(page).to have_content site_facility
      end
      within ".trial-sidebar" do
        expect(page).to have_css google_map_for_site(site)
        expect(page).to have_content resource_link_text
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
    fill_in("trial_filter_form[keyword]", with: keyword)
    apply_search_filter

    expect(page).to have_content displaying_one_trial

    click_link filtered_trial.title
    click_link return_to_search

    expect(page).to have_content displaying_one_trial
    expect(find_field(am_patient_field)).to be_checked
    expect(find_field(gender)).to be_checked
    expect(page).to have_field("trial_filter_form[keyword]", with: keyword)
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

    fill_in("trial_filter_form[age]", with: age)
    fill_in("trial_filter_form[keyword]", with: keyword)
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
    expect(page).to have_field("trial_filter_form[keyword]", with: keyword)
    expect(page).to have_field("trial_filter_form[age]", with: age)
  end

  scenario "User expands sections of content", :js do
    criteria = "This is the criteria"
    description = "This is the description"
    trial =
      create(:trial, detailed_description: description, criteria: criteria)
    trial_label = "/trials/#{trial.id}"
    site = trial.sites.first

    visit trial_path(trial)

    expect(page).not_to have_content criteria
    expect(page).not_to have_content description
    expect(page).not_to have_content site.zip_code

    find('[data-expand-item="Additional Criteria"]').click

    expect(page).to have_content criteria
    expect(page).not_to have_content description
    expect(page).not_to have_content site.zip_code
    expect_last_js_event("Additional Criteria", "Expanded", trial_label)

    find('[data-expand-item="Additional Criteria"]').click

    expect(page).not_to have_content criteria
    expect(page).not_to have_content description
    expect(page).not_to have_content site.zip_code
    expect_last_js_event("Additional Criteria", "Collapsed", trial_label)

    find('[data-expand-item="Site Details"]').click

    expect(page).not_to have_content criteria
    expect(page).not_to have_content description
    expect(page).to have_content site.zip_code
    expect_last_js_event("Site Details", "Expanded", trial_label)

    find('[data-expand-item="Site Details"]').click

    expect(page).not_to have_content criteria
    expect(page).not_to have_content description
    expect(page).not_to have_content site.zip_code
    expect_last_js_event("Site Details", "Collapsed", trial_label)

    find('[data-expand-item="Additional Details"]').click

    expect(page).not_to have_content criteria
    expect(page).to have_content description
    expect(page).not_to have_content site.zip_code
    expect_last_js_event("Additional Details", "Expanded", trial_label)

    find('[data-expand-item="Additional Details"]').click

    expect(page).not_to have_content criteria
    expect(page).not_to have_content description
    expect(page).not_to have_content site.zip_code
    expect_last_js_event("Additional Details", "Collapsed", trial_label)
  end

  scenario "User clicks contact info", :js do
    email = "user@example.com"
    phone = "234-567-8901"
    site = build(:site, contact_email: email, contact_phone: phone)
    trial = create(:trial, sites: [site])

    visit trial_path(trial)
    stub_links_to_prevent_default_for_testing

    click_link phone

    expect_last_js_event("Phone", "Site Contact Info", phone)

    click_link email

    expect_last_js_event("Email", "Site Contact Info", email)
  end

  def expect_last_js_event(name, category, label)
    expect(last_javascript_event.name).to eq name
    expect(last_javascript_event.properties).to include(
      "category" => category,
      "label" => label,
    )
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

  def stub_resource_link_request(url)
    stub_request(:get, url).to_return(
      status: 200,
      body: "<ul><li><a href='/'>#{resource_link_text}</a></li></ul>",
    )
  end

  def resource_link_text
    "Resource Link"
  end

  def stub_links_to_prevent_default_for_testing
    page.execute_script("$('a').attr('href', '#')")
  end

  def last_javascript_event
    event = page.evaluate_script("window.AnalyticsStub.lastEvent()")
    OpenStruct.new(event)
  end
end
