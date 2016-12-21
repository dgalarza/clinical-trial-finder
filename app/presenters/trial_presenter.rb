class TrialPresenter < SimpleDelegator
  MAX_AGE = 100
  PERIOD_ASCII = "&#46;".freeze

  VALID_USES_OF_PERIOD = [
    ["St.", "St#{PERIOD_ASCII}"],
    ["e.g.", "e#{PERIOD_ASCII}g#{PERIOD_ASCII}"],
    ["i.e.", "i#{PERIOD_ASCII}e#{PERIOD_ASCII}"],
    ["(ie.", "(ie#{PERIOD_ASCII}"],
    [" ie.", " ie#{PERIOD_ASCII}"],
    ["i.a.", "i#{PERIOD_ASCII}a#{PERIOD_ASCII}"],
    ["i.v.", "i#{PERIOD_ASCII}v#{PERIOD_ASCII}"],
    [/(\(|\s)vs./, "\\1vs#{PERIOD_ASCII}"],
    [" etc.", " etc#{PERIOD_ASCII}"],
    [" ver.", " ver#{PERIOD_ASCII}"],
    [/(\d)\.(\d)/, "\\1#{PERIOD_ASCII}\\2"]
  ].freeze

  def to_s
    title
  end

  def description_as_markup
    parse(description)
  end

  def detailed_description_as_markup
    parse(detailed_description)
  end

  def criteria_as_markup
    parse(criteria_with_header_tags)
  end

  def age_range
    "#{minimum_age_original} #{max_age_value}"
  end

  def healthy_volunteers_as_yes_no
    if healthy_volunteers == "Accepts Healthy Volunteers"
      "Yes"
    elsif healthy_volunteers == "No"
      "No"
    else
      "Unknown"
    end
  end

  private

  def max_age_value
    if maximum_age >= MAX_AGE
      "and Over"
    else
      "- #{maximum_age_original}"
    end
  end

  def criteria_with_header_tags
    if criteria.present?
      criteria.gsub(/((?:Exclusion|Inclusion) Criteria:)/i, "<h2>\\1</h2>")
    end
  end

  def parse(value)
    if value.present?
      value_with_periods(value).
        gsub(/\s(#{start_of_item_regex})\s([^.]+\.)/, "<li>\\1 \\2</li>").
        gsub(/<li>/, "<ul><li>").
        gsub(/\s*<\/li>\s*/, "</li></ul>")
    end
  end

  def value_with_periods(value)
    VALID_USES_OF_PERIOD.each do |valid_use|
      value.gsub!(valid_use[0], valid_use[1])
    end

    value
  end

  def start_of_item_regex
    /-|#{number_wrapped_in_parenthesis}|#{roman_numeral}/
  end

  def number_wrapped_in_parenthesis
    /\(\d\)/
  end

  def roman_numeral
    /(?:I{1,3}|IV|V|VI|VII|VIII|IX|X)\./
  end
end
