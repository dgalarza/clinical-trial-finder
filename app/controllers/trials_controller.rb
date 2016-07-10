class TrialsController < ApplicationController
  def index
    @trials = build_trials
    @last_import = ImportLog.last
  end

  def show
    @trial = Trial.find(trial_id)
  end

  private

  def build_trials
    Trial
      .search_for(filter_params[:keyword])
      .age(filter_params[:age])
      .control(filter_params[:control])
      .gender(filter_params[:gender])
      .paginate(page: all_params[:page])
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
        :gender,
        :keyword
      ]
    )
  end

  def trial_id
    params.require(:id)
  end
end
