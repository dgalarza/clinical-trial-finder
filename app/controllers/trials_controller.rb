class TrialsController < ApplicationController
  def index
    @trials = Trial.all
  end

  def show
    @trial = Trial.find(trial_id)
  end

  private

  def trial_id
    params.require(:id)
  end
end
