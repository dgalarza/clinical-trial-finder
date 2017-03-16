module Admin
  class ImportLogsController < ApplicationController
    def index
      @import_logs = ImportLog.all.order(created_at: :desc).paginate(page: page)
      @newest_trial = Trial.order(created_at: :desc).first
    end

    private

    def page
      params.permit(:page)[:page]
    end
  end
end
