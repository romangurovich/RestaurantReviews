INSERT INTO chefs ('first_name', 'last_name', 'mentor') VALUES
  ("Gandalf", "White", NULL),
  ("Trebek's Mother", "Trebek", NULL),
  ("Sean", "Connery", 2),
  ("Frodo", "Baggins", 1),
  ("Clint", "Eastwood", 3),
  ("Freddy", "Krueger", 3),
  ("Loch Ness", "Monster", 3),
  ("Captain", "Planet", 1);

INSERT INTO restaurants ('name', 'neighborhood', 'cuisine') VALUES
  ("Speedy's Taco Stand", "Compton", "Mexican"),
  ("Make My Day Cafe", "Garment District", "Nouveau-Californian"),
  ("The Lake", "Echo Park", "Mexican"),
  ("The Shire", "Echo Park", "Steakhouse"),
  ("The Boudoir", "Hollywood", "Steakhouse"),
  ("On The Bridge", "Hollywood", "Mexican"),
  ("Bumcover", "Hollywood", "Traditional");

INSERT INTO chef_tenure ('chef_id', 'restaurant_id', 'start_date', 'end_date', 'is_head_chef') VALUES
  (1, 6, '2012-02-20', '2013-02-20', 1),
  (2, 5, '2008-04-12', '2011-08-08', 1),
  (3, 7, '2010-02-20', '2013-02-20', 1),
  (4, 4, '2012-02-20', '2012-11-20', 0),
  (5, 2, '2003-02-20', '2013-02-20', 1),
  (6, 3, '2005-07-20', '2013-02-20', 0),
  (7, 3, '2005-07-20', '2013-02-20', 1),
  (8, 1, '2005-02-20', '2013-02-20', 1),
  (3, 4, '2005-02-20', '2010-01-01', 1);

INSERT INTO critics ('screen_name') VALUES
  ("SirCharles"),
  ("Trebek"),
  ("Bilbo"),
  ("Batman");

INSERT INTO restaurant_reviews ('critic_id', 'restaurant_id', 'body', 'score', 'review_date') VALUES
  (1, 7, "The food here was turrible", 11, '2012-03-20'),
  (2, 5, "Tastes like home", 18, '2012-02-18'),
  (2, 7, "Gross", 2, '2012-02-20'),
  (3, 4, "Not bad lads. Complimetary pipe.", 17, '2012-02-20'),
  (4, 4, "Kind of cheap, but kind of good.", 15, '2012-03-13'),
  (3, 4, "Damn you Sean Connery! This isn't hobbit food!", 15, '2006-03-13');
