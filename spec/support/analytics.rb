module Analytics
  def analytics
    Rails.application.config.analytics
  end
end

RSpec.configure do |config|
  config.include Analytics
end
