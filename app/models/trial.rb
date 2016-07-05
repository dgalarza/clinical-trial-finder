class Trial < ActiveRecord::Base
  has_many :sites

  def self.search_for(query)
    where("title ILIKE :query OR description ILIKE :query", query: "%#{query}%")
  end
end
