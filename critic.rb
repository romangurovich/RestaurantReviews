require_relative 'reviewsdb'
require_relative 'restaurant_review'

class Critic
  def self.find(id)
    query = <<-SQL
    SELECT * FROM critics
    WHERE id = ?
    SQL

    Critic.new(ReviewsDB.instance.execute(query, id).first)
  end

  attr_reader :id
  attr_accessor :screen_name

  def initialize(options = {})
    @id, @screen_name = options.values_at('id', 'screen_name')
  end

  def attrs
    { :id => id,
      :screen_name => screen_name }
  end

  def save
    if @id
      ReviewsDB.instance.execute(<<-SQL, attrs)
        UPDATE restaurants
        SET screen_name => :screen_name
        WHERE critics.id = :id
      SQL
    else
      ReviewsDB.instance.execute(<<-SQL, attrs)
        INSERT INTO restaurants (screen_name)
        VALUES (:screen_name)
      SQL

      @id = ReviewsDB.instance.last_insert_row_id
    end
  end

  def reviews
    RestaurantReview.find_by_critic(id)
  end

  def average_review_score
    RestaurantReview.average_score_by_critic(id)
  end

  def unreviewed_restaurants
    query = <<-SQL
      SELECT a.* FROM restaurants a
      JOIN restaurant_reviews b ON (a.id = b.restaurant_id)
      JOIN critics c ON (b.critic_id = c.id)
      WHERE b.critic_id != ?
    SQL

    ReviewsDB.instance.execute(query, id).map do |restaurant|
      Restaurant.new(restaurant)
    end
  end
end
