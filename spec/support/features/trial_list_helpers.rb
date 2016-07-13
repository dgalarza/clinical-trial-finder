module TrialListHelpers
  def displaying_multiple_trials(count)
    t("trials.trial_count.displaying.other", count: count)
  end

  def am_patient_field
    t("helpers.search_filter.am_patient")
  end

  def apply_search_filter
    click_button t("trials.search_filter.submit")
  end

  def displaying_one_trial
    t("trials.trial_count.displaying.one")
  end
end
