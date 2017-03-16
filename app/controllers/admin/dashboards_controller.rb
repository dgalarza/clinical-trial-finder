module Admin
  class DashboardsController < ApplicationController
    def show
      @last_import = ImportLog.last
      @newest_trial = Trial.order(created_at: :desc).first
      @sites_without_coordinates = Site.without_coordinates
    end
  end
end
