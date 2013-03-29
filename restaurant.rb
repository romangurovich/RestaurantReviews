require_relative 'reviewsdb'

class Restaurant
  def self.find(id)
    query = <<-SQL
    SELECT * FROM restaurants
    WHERE id = ?
    SQL

    Restaurant.new(ReviewsDB.instance.execute(query, id).first)
  end

  def self.by_neighborhood(neighborhood)
    query = <<-SQL
    SELECT * FROM restaurants
    WHERE neighborhood LIKE ?
    SQL

    ReviewsDB.instance.execute(query, "%#{neighborhood}%").map do |restaurant|
      Restaurant.new(restaurant)
    end
  end

  def self.top_restaurants(n)
    query = <<-SQL
    SELECT restaurants.* FROM restaurants
    JOIN
    (SELECT restaurant_id, AVG(score) avg_score FROM restaurant_reviews
    GROUP BY restaurant_id) avg_scores_subquery
    ON restaurants.id = avg_scores_subquery.restaurant_id
    ORDER BY avg_scores_subquery.avg_score DESC
    LIMIT ?
    SQL

    ReviewsDB.instance.execute(query, n).map do |restaurant|
      Restaurant.new(restaurant)
    end

  end

  def self.highly_reviewed_restaurants(min_reviews)
    query = <<-SQL
    SELECT restaurants.* FROM restaurants
    JOIN
    (SELECT restaurant_id, AVG(score) avg_score, COUNT(score) num_reviews
    FROM restaurant_reviews
    GROUP BY restaurant_id) avg_scores_subquery
    ON restaurants.id = avg_scores_subquery.restaurant_id
    WHERE num_reviews >= ?
    ORDER BY avg_scores_subquery.avg_score DESC
    SQL

    ReviewsDB.instance.execute(query, min_reviews).map do |restaurant|
      Restaurant.new(restaurant)
    end

  end

  attr_reader :id
  attr_accessor :name, :neighborhood, :cuisine

  def initialize(options = {})
    @id, @name, @neighborhood, @cuisine =
    options.values_at('id', 'name', 'neighborhood', 'cuisine')
  end

  def attrs
    { :id => id,
      :name => name,
      :neighborhood => neighborhood,
      :cuisine => cuisine }
  end

  def save
    if @id
      ReviewsDB.instance.execute(<<-SQL, attrs)
        UPDATE restaurants
        SET name => :name, neighborhood = :neighborhood, cuisine = :cuisine
        WHERE restaurants.id = :id
      SQL
    else
      ReviewsDB.instance.execute(<<-SQL, attrs)
        INSERT INTO restaurants (name, neighborhood, cuisine)
        VALUES (:name, :neighborhood, :cuisine)
      SQL

      @id = ReviewsDB.instance.last_insert_row_id
    end
  end

  def reviews
    RestaurantReview.find_by_restaurant(id)
  end

  def average_review_score
    RestaurantReview.average_score_by_restaurant(id)
  end

end