class TrialsController < ApplicationController
  def index
    cache_filters
    @trials = build_trials
    @last_import = ImportLog.last
  end

  def show
    @trial = Trial.joins(:sites).find(trial_id)
  end

  private

  def cache_filters
    session[:search_params] = all_params
  end

  def build_trials
    trials = Trial
      .search_for(filter_params[:keyword])
      .age(filter_params[:age])
      .control(filter_params[:control])
      .gender(filter_params[:gender])
      .close_to(close_to_arguments)

    session[:search_results] = trials.pluck(:id)

    trials.paginate(page: all_params[:page])
  end

  def filter_params
    all_params.fetch(:trial_filter, {})
  end

  def all_params
    params.permit(
      :commit,
      :page,
      :utf8,
      trial_filter: [
        :age,
        :control,
        :distance_radius,
        :gender,
        :keyword,
        :zip_code
      ]
    )
  end

  def close_to_arguments
    {
      zip_code: filter_params[:zip_code],
      radius: filter_params[:distance_radius]
    }
  end

  def trial_id
    params.require(:id)
  end
end
