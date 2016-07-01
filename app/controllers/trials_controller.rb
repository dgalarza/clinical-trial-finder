class TrialsController < ApplicationController
  def index
    @trials = Trial.all
    @last_import = ImportLog.last
  end

  def show
    @trial = Trial.find(trial_id)
  end

  private

  def trial_id
    params.require(:id)
  end
end
