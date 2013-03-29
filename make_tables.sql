CREATE TABLE chefs (
  id INTEGER PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  mentor INTEGER,
  FOREIGN KEY (mentor) REFERENCES chefs(id)
);

CREATE TABLE restaurants (
  id INTEGER PRIMARY KEY,
  name VARCHAR(100),
  neighborhood VARCHAR(100),
  cuisine VARCHAR(100)
);

CREATE TABLE chef_tenure (
  id INTEGER PRIMARY KEY,
  chef_id INTEGER,
  restaurant_id INTEGER,
  start_date DATE,
  end_date DATE,
  is_head_chef INTEGER,
  FOREIGN KEY (chef_id) REFERENCES chefs(id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
  CHECK (is_head_chef IN (0, 1)),
  CHECK (end_date > start_date)
);

CREATE TABLE critics (
  id INTEGER PRIMARY KEY,
  screen_name VARCHAR(100)
);

CREATE TABLE restaurant_reviews (
  id INTEGER PRIMARY KEY,
  critic_id INTEGER,
  restaurant_id INTEGER,
  body TEXT,
  score INTEGER,
  review_date DATE,
  FOREIGN KEY (critic_id) REFERENCES critics(id),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
  CHECK (score BETWEEN 1 AND 20)
);








