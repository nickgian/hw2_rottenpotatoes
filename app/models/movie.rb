class Movie < ActiveRecord::Base
  def self.all_ratings
    select(:rating).map { |c| c.rating }.uniq
  end
end
