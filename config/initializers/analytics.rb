analytics_service = Rails.application.config.analytics_service
Rails.application.config.analytics = analytics_service.new(
  write_key: ENV.fetch("SEGMENT_KEY"),
  on_error: Proc.new { |_status, msg| Rails.logger.debug(msg) },
)
