class TrialPresenter < SimpleDelegator
  def description_as_markup
    parse(description)
  end

  def detailed_description_as_markup
    parse(detailed_description)
  end

  def criteria_as_markup
    parse(criteria_with_header_tags)
  end

  private

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
