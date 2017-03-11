class MockAnalytics
  cattr_reader :events

  def self.reset
    @@events = []
  end

  def initialize(*)
    @@events = []
  end

  def init(*); end

  def track(*attributes)
    @@events << attributes
  end

  def identify(*); end

  def flush; end
end
