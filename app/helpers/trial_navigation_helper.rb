module TrialNavigationHelper
  def previous_trial_link(trial_id)
    index = search_results.index(trial_id)
    previous_id = search_results[index - 1]
    if index > 0
      link_to raw("&#10094; #{t("trials.navigation.previous_trial")}"), trial_path(previous_id), class: "previous-trial"
    end
  end

  def next_trial_link(trial_id)
    search_results = session[:search_results].dup
    index = search_results.index(trial_id)
    next_trial_id = search_results[index + 1]

    if next_trial_id
      link_to raw("#{t("trials.navigation.next_trial")} &#10095;"), trial_path(next_trial_id), class: "next-trial"
    end
  end
end
