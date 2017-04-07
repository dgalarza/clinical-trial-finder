class ConditionsQueryBuilder
  def self.transform(conditions)
    new(conditions).transform
  end

  def initialize(conditions)
    @conditions = conditions
  end

  def transform
    URI.encode joined_conditions
  end

  private

  attr_reader :conditions

  def joined_conditions
    conditions.gsub("\r\n", "+OR+")
  end
end
