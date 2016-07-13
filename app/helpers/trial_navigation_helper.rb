module TrialNavigationHelper
  def previous_trial_link(trial_id)
    index = search_results.index(trial_id)
    previous_id = search_results[index - 1]
    if index > 0
      link_to t("trials.navigation.previous_trial"), trial_path(previous_id)
    end
  end

  def next_trial_link(trial_id)
    search_results = session[:search_results].dup
    index = search_results.index(trial_id)
    next_trial_id = search_results[index + 1]

    if next_trial_id
      link_to t("trials.navigation.next_trial"), trial_path(next_trial_id)
    end
  end
end
