class ImportLogsController < ApplicationController
  def index
    @import_logs = ImportLog.all.order(created_at: :desc)
  end
end
