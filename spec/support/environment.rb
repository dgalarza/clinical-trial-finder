module Environment
  def with_environment(options)
    original_environment = {}

    options.each do |key, value|
      original_environment[key] = ENV[key]
      ENV[key] = value
    end

    yield

  ensure
    original_environment.each do |key, value|
      ENV[key] = value
    end
  end
end

RSpec.configure do |c|
  c.include Environment
end
