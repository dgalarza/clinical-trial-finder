require "rails_helper"

RSpec.feature "admin visits dashboard" do
  scenario "admin visits dashboard" do
    trial_count = 100
    create(:import_log, trial_count: trial_count)
    newest_trial = create(:trial)
    create(:site, :without_lat_long, trial: newest_trial)

    visit admin_dashboard_path

    expect(page).to have_content trial_count
    expect(page).to have_content newest_trial.created_at
    expect(page).to have_content(
      t("admin.dashboards.show.sites_without_coordinates", count: 1),
    )
  end
end
