class TrialFilterForm
  ZIP_CODE_MATCH = /\A\d{5}(-\d{4})?\z/

  include ActiveModel::Model

  attr_accessor(
    :age,
    :control,
    :distance_radius,
    :gender,
    :keyword,
    :page,
    :study_type,
    :zip_code,
  )

  validates(
    :zip_code,
    format: {
      with: ZIP_CODE_MATCH,
      message: "not a valid zip code",
      allow_blank: true,
    }
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

  def trials
    if valid?
      trials = Trial
        .sites_present
        .search_for(keyword)
        .age(age)
        .control(control)
        .gender(gender)
        .study_type(study_type)
        .close_to(close_to_arguments)

      trials.paginate(page: page)
    else
      Trial.none
    end
  end

  private

  def close_to_arguments
    {
      zip_code: zip_code,
      radius: distance_radius,
    }
  end
end
