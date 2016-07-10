module ViewHelpers
  def page
    @page ||= Capybara.string(rendered)
  end
end

RSpec.configure do |config|
  config.include ViewHelpers, type: :view
end
