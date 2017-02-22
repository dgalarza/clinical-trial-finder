module TrialListHelpers
  def displaying_multiple_trials(count)
    t("will_paginate.page_entries_info.single_page_html.other", count: count)
  end

  def am_patient_field
    t("helpers.search_filter.am_patient")
  end

  def apply_search_filter
    click_button t("trials.search_filter.submit")
  end

  def displaying_one_trial
    t("will_paginate.page_entries_info.single_page_html.one")
  end
end
