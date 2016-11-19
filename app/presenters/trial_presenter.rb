class TrialPresenter < SimpleDelegator
  MAX_AGES = ["N/A", "120 Years", "100 Years", "99 Years"].freeze

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

  private

  def max_age_value
    if maximum_age_original.in? MAX_AGES
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
      value.gsub(/\s#{start_of_item_regex}\s([^.]+\.)/, "<li>\\1</li>").
        gsub(/<li>/, "<ul><li>").
        gsub(/\s*<\/li>\s*/, "</li></ul>")
    end
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
