require "rails_helper"

RSpec.feature "User visits import logs" do
  scenario "user visits import logs" do
    trial_count = 5
    site_count = 15
    import_log = create(
      :import_log,
      trial_count: trial_count,
      site_count: site_count
    )

    visit import_logs_path

    expect(page).to have_content import_log.created_at
    expect(page).to have_content import_log.site_count
    expect(page).to have_content import_log.trial_count
  end
end
