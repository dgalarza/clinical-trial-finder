class TrialsController < ApplicationController
  def index
    @trials = build_trials_list
    @last_import = ImportLog.last
  end

  def show
    @trial = Trial.find(trial_id)
  end

  private

  def build_trials_list
    Trial
      .search_for(filtered_params[:keyword])
      .paginate(page: filtered_params[:page])
  end

  def filtered_params
    params.permit(:keyword, :utf8, :commit, :page)
  end

  def trial_id
    params.require(:id)
  end
end
