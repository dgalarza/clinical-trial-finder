module TrialPageHelper
  def show_nearest_site?(count:)
    session[:zip_code_coordinates].present? || (count == 1)
  end
end
