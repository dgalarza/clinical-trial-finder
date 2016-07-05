class TrialsController < ApplicationController
  def index
    @trials = Trial.search_for(trial_filter_params[:keyword])
    @last_import = ImportLog.last
  end

  def show
    @trial = Trial.find(trial_id)
  end

  private

  def trial_filter_params
    params.permit(:keyword, :utf8, :commit)
  end

  def trial_id
    params.require(:id)
  end
end
