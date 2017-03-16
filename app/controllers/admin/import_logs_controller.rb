module Admin
  class ImportLogsController < ApplicationController
    def index
      @import_logs = ImportLog.all.order(created_at: :desc).paginate(page: page)
    end

    private

    def page
      params.permit(:page)[:page]
    end
  end
end
