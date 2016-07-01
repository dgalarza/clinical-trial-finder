require "rails_helper"

RSpec.feature "User browses navigation" do
  scenario "User browses navigation" do
    ImportLog.create
    visit root_path

    expect(page).to have_content t("homepage.show.overview")

    click_link t("application.navigation.trial_connector")

    expect(page).to have_content t("titles.trials.index")

    click_link t("application.navigation.blog")

    expect(page).to have_content t("titles.articles.index")

    click_link t("application.navigation.faq")

    expect(page).to have_content t("titles.frequently_asked_questions.index")

    click_link t("application.navigation.overview")

    expect(page).to have_content t("titles.homepage.show")
  end
end
