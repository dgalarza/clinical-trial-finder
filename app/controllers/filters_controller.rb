class FiltersController < ApplicationController
  def destroy
    reset_session

    redirect_to trials_path(reset: true)
  end
end
