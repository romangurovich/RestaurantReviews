require 'singleton'
require 'sqlite3'

class ReviewsDB < SQLite3::Database
  include Singleton

  def initialize
    super('reviews.db')

    self.results_as_hash  = true
    self.type_translation = true
  end
end