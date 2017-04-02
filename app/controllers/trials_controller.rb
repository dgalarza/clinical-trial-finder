class TrialsController < ApplicationController
  def index
    @trial_filter_form = TrialFilterForm.new(filter_form_params)

    if @trial_filter_form.valid?
      cache_filters(@trial_filter_form)
      session[:search_results] = @trial_filter_form.trial_ids
    end
  end

  def show
    @trial = TrialPresenter.new(trial)
  end

  private

  def trial
    Trial.find(trial_id)
  end

  def cache_filters(filter)
    session[:search_params] = all_params
    session[:zip_code_coordinates] = filter.coordinates
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
    params.permit(application_parameters + google_parameters)
  end

  def application_parameters
    [
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
    ]
  end

  def google_parameters
    %i(utm_source utm_content utm_medium utm_campaign)
  end

  def zip_code_filter
    filter_params[:zip_code]
  end

  def trial_id
    params.require(:id)
  end
end
