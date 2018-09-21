class Movie < ActiveRecord::Base

  all_ratings =

  def self.get_ratings
    return %w[G PG PG-13 R]
  end
end
