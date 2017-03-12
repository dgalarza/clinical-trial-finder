class FiltersController < ApplicationController
  RESET_EVENT = "Filter Cleared".freeze

  def destroy
    reset_session
    analytics.track(event: RESET_EVENT, anonymous_id: session.id)

    redirect_to trials_path(reset: true)
  end

  private

  def analytics
    Rails.application.config.analytics
  end
end
