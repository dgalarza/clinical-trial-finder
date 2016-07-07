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
      .search_for(filtered_params[:keyword])
      .age(filtered_params[:age])
      .gender(filtered_params[:gender])
      .paginate(page: filtered_params[:page])
  end

  def filtered_params
    params.permit(
      :age,
      :commit,
      :gender,
      :keyword,
      :page,
      :utf8
    )
  end

  def trial_id
    params.require(:id)
  end
end
