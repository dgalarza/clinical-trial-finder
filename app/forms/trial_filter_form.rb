class TrialFilterForm
  EMPTY_FILTER_APPLIED_EVENT = "Empty Filter Applied".freeze
  FILTER_APPLIED_EVENT = "Filter Applied".freeze
  FILTER_WITH_VALUE_ALWAYS_SET = "distance_radius".freeze
  NON_FILTER = "session_id".freeze
  ZIP_CODE_MATCH = /\A\d{5}(-\d{4})?\z/

  include ActiveModel::Model

  attr_accessor(
    :age,
    :control,
    :distance_radius,
    :gender,
    :keyword,
    :page,
    :session_id,
    :study_type,
    :zip_code,
  )

  validates(
    :age,
    numericality: {
      only_integer: true,
      allow_blank: true,
      less_than_or_equal_to: 120,
      greater_than_or_equal_to: 1
    }
  )
  validate :valid_zip_code

  def valid_zip_code
    if zip_code.present? && zip_code_record.nil?
      errors.add(:zip_code, "is not a valid 5-digit zip")
    end
  end

  def initialize(*args)
    super(*args)
    track_events(*args)
  end

  def trials
    @trials ||= if valid?
                  filtered_trials.paginate(page: page)
                else
                  Trial.none
                end
  end

  def trial_ids
    filtered_trials.pluck(:id)
  end

  def coordinates
    if zip_code_record.present?
      zip_code_record.coordinates
    end
  end

  private

  def zip_code_record
    ZipCode.find_by(zip_code: zip_code)
  end

  def filtered_trials
    Trial
      .search_for(keyword)
      .age(age)
      .control(control)
      .gender(gender)
      .study_type(study_type)
      .close_to(close_to_arguments)
  end

  def close_to_arguments
    {
      zip_code: zip_code,
      radius: distance_radius,
    }
  end

  def analytics
    Rails.application.config.analytics
  end

  def track_events(args = {})
    filters = args.dup.except!(NON_FILTER)
    if filters.present?
      filters_with_value = fetch_filters_with_value(filters)
      track_filter_event(filters_with_value)
    end
  end

  def track_filter_event(filters)
    event = if filters.present?
              analytics_event.merge(
                event: FILTER_APPLIED_EVENT,
                properties: event_properties,
              )
            else
              analytics_event.
                merge(event: EMPTY_FILTER_APPLIED_EVENT)
            end
    analytics.track(event)
  end

  def analytics_event
    { anonymous_id: session_id }
  end

  def fetch_filters_with_value(filters)
    filters.dup.except!(FILTER_WITH_VALUE_ALWAYS_SET).
      keep_if { |_, value| value.present? }
  end

  def event_properties
    {
      age: age_as_integer,
      control_only: control,
      distance_radius: distance_radius.to_i,
      gender: gender,
      keyword: keyword.try(:downcase),
      match_count: trials.count,
      study_type: study_type,
      zip_code: zip_code,
    }.delete_if { |_, v| v.blank? }
  end

  def age_as_integer
    age.to_i if age.present?
  end
end
