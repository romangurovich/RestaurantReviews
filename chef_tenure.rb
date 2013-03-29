require_relative 'reviewsdb'

class ChefTenure
  def self.find(id)
    query = <<-SQL
    SELECT * FROM restaurants
    WHERE id = ?
    SQL

    ChefTenure.new(ReviewsDB.instance.execute(query, id).first)
  end

  attr_reader :id
  attr_accessor :chef_id, :restaurant_id, :start_date, :end_date, :is_head_chef

  def initialize(options = {})
    @id, @chef_id, @restaurant_id, @start_date, @end_date, @is_head_chef =
    options.values_at('id', 'chef_id', 'restaurant_id', 'start_date',
      'end_date', 'is_head_chef')
  end

  def attrs
    { :chef_id => chef_id,
      :restaurant_id => restaurant_id,
      :start_date => start_date,
      :end_date => end_date,
      :is_head_chef => is_head_chef }
  end

  def save
    if @id
      ReviewsDB.instance.execute(<<-SQL, attrs.merge({:id => id}))
        UPDATE chef_tenure
        SET chef_id => :chef_id, restaurant_id = :restaurant_id,
          start_date = :start_date, end_date => :end_date,
          is_head_chef => :is_head_chef
        WHERE chef_tenure.id = :id
      SQL
    else
      ReviewsDB.instance.execute(<<-SQL, attrs)
        INSERT INTO chef_tenure
        (chef_id, restaurant_id, start_date, end_date, is_head_chef)
        VALUES (:chef_id, :restaurant_id, :start_date, :end_date, :is_head_chef)
      SQL

      @id = ReviewsDB.instance.last_insert_row_id
    end
  end
end