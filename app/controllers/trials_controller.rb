class TrialsController < ApplicationController
  def index
    @trial_filter_form = TrialFilterForm.new(filter_form_params)

    if @trial_filter_form.valid?
      cache_filters
      session[:search_results] = @trial_filter_form.trial_ids
    end
  end

  def show
    @trial = TrialPresenter.new(trial_with_sites)
  end

  private

  def trial_with_sites
    Trial.joins(:sites).find(trial_id)
  end

  def cache_filters
    session[:search_params] = all_params
    set_zip_code_coordinates
  end

  def set_zip_code_coordinates
    if zip_code_filter.present?
      coordinates = ZipCode.find_by(zip_code: zip_code_filter).coordinates
    else
      coordinates = nil
    end

    session[:zip_code_coordinates] = coordinates
  end

  def filter_form_params
    filter_params.merge(page_params).merge(session_id: session.id)
  end

  def page_params
    Hash[*all_params.assoc("page")]
  end

  def filter_params
    all_params.fetch(:trial_filter_form, {})
  end

  def all_params
    params.permit(
      :commit,
      :page,
      :reset,
      :utf8,
      trial_filter_form: [
        :age,
        :control,
        :distance_radius,
        :gender,
        :keyword,
        :study_type,
        :zip_code
      ]
    )
  end

  def zip_code_filter
    filter_params[:zip_code]
  end

  def trial_id
    params.require(:id)
  end
end
