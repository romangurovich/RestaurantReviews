require_relative 'reviewsdb'

class Chef
  def self.find(id)
    query = <<-SQL
    SELECT * FROM chefs
    WHERE id = ?
    SQL

    Chef.new(ReviewsDB.instance.execute(query, id).first)
  end

  attr_reader :id
  attr_accessor :first_name, :last_name, :mentor

  def initialize(options = {})
    @id, @first_name, @last_name, @mentor =
    options.values_at('id', 'first_name', 'last_name', 'mentor')
  end

  def attrs
    { :id => id,
      :first_name => first_name,
      :last_name => last_name,
      :mentor => mentor }
  end

  def save
    if @id
      ReviewsDB.instance.execute(<<-SQL, attrs)
        UPDATE chefs
        SET first_name => :first_name, last_name = :last_name, mentor = :mentor
        WHERE chefs.id = :id
      SQL
    else
      ReviewsDB.instance.execute(<<-SQL, attrs)
        INSERT INTO chefs (first_name, last_name, mentor)
        VALUES (:first_name, :last_name, :mentor)
      SQL

      @id = ReviewsDB.instance.last_insert_row_id
    end
  end

  def proteges
    query = <<-SQL
      SELECT * FROM chefs a
      JOIN chefs b
      ON (a.id = b.mentor)
      WHERE a.id = ?
    SQL

    ReviewsDB.instance.execute(query, id).map do |protege|
      Chef.new(protege)
    end
  end

  def num_proteges
    query = <<-SQL
      SELECT COUNT(b.mentor) num_proteges FROM chefs a JOIN chefs b
      ON (a.id = b.mentor)
      WHERE a.id = ?
    SQL

    ReviewsDB.instance.execute(query, id).first['num_proteges']
  end

  def co_workers
    query = <<-SQL
      SELECT a.* FROM chefs a
      JOIN chef_tenure b ON (a.id = b.chef_id)
      JOIN chef_tenure c ON (b.chef_id = c.chef_id)
      WHERE b.chef_id = ?
      AND b.restaurant_id = c.restaurant_id
      AND
        (b.start_date BETWEEN c.start_date AND c.end_date)
          OR
        (b.end_date BETWEEN c.start_date AND c.end_date)
    SQL

    ReviewsDB.instance.execute(query, id).map do |co_worker|
      Chef.new(co_worker)
    end

  end

  def reviews
    query = <<-SQL
      SELECT a.* FROM restaurant_reviews a
      JOIN chef_tenure b ON a.restaurant_id = b.restaurant_id
      WHERE b.chef_id = ?
      AND b.is_head_chef = 1
      AND a.review_date BETWEEN b.start_date AND b.end_date
    SQL

    ReviewsDB.instance.execute(query, id).map do |review|
      RestaurantReview.new(review)
    end
  end

end
