class Movie < ActiveRecord::Base
  def self.ratings 
    ['G','PG','PG-13','R']
  	#self.uniq.order(:rating).pluck(:rating)
  end
end
