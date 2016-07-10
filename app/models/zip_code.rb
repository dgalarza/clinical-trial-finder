class ZipCode < ActiveRecord::Base
  def coordinates
    [latitude.to_f, longitude.to_f]
  end
end
