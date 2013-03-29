require_relative 'reviewsdb'

class RestaurantReview
  def self.find(id)
    query = <<-SQL
    SELECT * FROM restaurant_reviews
    WHERE id = ?
    SQL

    RestaurantReview.new(ReviewsDB.instance.execute(query, id).first)
  end

  def self.find_by_critic(critic_id)
    query = <<-SQL
    SELECT * FROM restaurant_reviews
    WHERE critic_id = ?
    SQL

    ReviewsDB.instance.execute(query, critic_id).map do |review|
      RestaurantReview.new(review)
    end
  end

  def self.average_score_by_critic(critic_id)
    query = <<-SQL
    SELECT AVG(score) avg_score FROM restaurant_reviews
    WHERE critic_id = ?
    SQL

    ReviewsDB.instance.execute(query, critic_id).first['avg_score']
  end

  def self.find_by_restaurant(restaurant_id)
    query = <<-SQL
    SELECT * FROM restaurant_reviews
    WHERE restaurant_id = ?
    SQL

    ReviewsDB.instance.execute(query, restaurant_id).map do |review|
      RestaurantReview.new(review)
    end
  end

  def self.average_score_by_restaurant(restaurant_id)
    query = <<-SQL
    SELECT AVG(score) avg_score FROM restaurant_reviews
    WHERE restaurant_id = ?
    SQL

    ReviewsDB.instance.execute(query, restaurant_id).first['avg_score']
  end

  attr_reader :id
  attr_accessor :critic_id, :restaurant_id, :body, :score, :review_date

  def initialize(options = {})
    @id, @critic_id, @restaurant_id, @body, @score, @review_date =
    options.values_at('id', 'critic_id', 'restaurant_id',
      'body', 'score', 'review_date')
  end

  def attrs
    { :id => id,
      :critic_id => critic_id,
      :restaurant_id => restaurant_id,
      :body => body,
      :score => score,
      :review_date => review_date }
  end

  def save
    if @id
      ReviewsDB.instance.execute(<<-SQL, attrs)
        UPDATE restaurant_reviews
        SET critic_id => :critic_id, restaurant_id => :restaurant_id,
            body => :body, score => :score, review_date => :review_date
        WHERE restaurant_reviews.id = :id
      SQL
    else
      ReviewsDB.instance.execute(<<-SQL, attrs)
        INSERT INTO restaurant_reviews ('critic_id', 'restaurant_id',
          'body', 'score', 'review_date')
        VALUES (:critic_id, :restaurant_id, :body, :score, :review_date)
      SQL

      @id = ReviewsDB.instance.last_insert_row_id
    end
  end

end
