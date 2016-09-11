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
    set_zip_code_coordinates
  end

  def set_zip_code_coordinates
    if zip_code_filter.present?
      coordinates = ZipCode.find_by(zip_code: zip_code_filter).coordinates
    else
      coordinates = nil
    end

    session[:zip_code_coordinates] = coordinates
  end

  def build_trials
    trials = Trial
      .sites_present
      .search_for(filter_params[:keyword])
      .age(filter_params[:age])
      .control(filter_params[:control])
      .gender(filter_params[:gender])
      .study_type(filter_params[:study_type])
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
        :study_type,
        :zip_code
      ]
    )
  end

  def close_to_arguments
    {
      zip_code: zip_code_filter,
      radius: filter_params[:distance_radius]
    }
  end

  def zip_code_filter
    filter_params[:zip_code]
  end

  def trial_id
    params.require(:id)
  end
end
