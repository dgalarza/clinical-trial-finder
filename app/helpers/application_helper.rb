module ApplicationHelper
  def search_results
    session[:search_results]
  end

  def analytics_js_library
    if Rails.env.test?
      "mock_analytics"
    else
      "analytics"
    end
  end
end
