create database artdatabase;

\c artdatabase


CREATE TABLE users (
  id SERIAL4 PRIMARY KEY,
  name VARCHAR(20) NOT NULL,
  email VARCHAR(100) NOT NULL,
  password_digest VARCHAR(400) NOT NULL
);



CREATE TABLE paintings (
  id SERIAL4 PRIMARY KEY,
  title VARCHAR(100),
  img_url VARCHAR(300),
  author VARCHAR(100),
  century VARCHAR(100),
  style VARCHAR(100),
  seen_live VARCHAR(10),
  city VARCHAR(300),
  museum VARCHAR(100),
  user_id INTEGER
);

INSERT INTO paintings (title, img_url, author, century, style, seen_live, city) VALUES
              ('The Kiss', 'http://www.myfreewallpapers.net/artistic/wallpapers/gustav-klimt-the-kiss.jpg', 'Gustav Klimt','XX', 'Art Nouveau', 'yes', 'Vienna');


ALTER TABLE paintings ADD museum VARCHAR(100);



ALTER TABLE paintings ADD latitude real;
ALTER TABLE paintings ADD longitude real;


-- ALTER TABLE paintings ADD map ?????????;

-- ALTER TABLE paintings ADD user_id INTEGER;  FOR LIKES TABLE
-- ALTER TABLE comments ADD user_id INTEGER;  FOR LIKES TABLE


CREATE TABLE comments (
  id SERIAL4 PRIMARY KEY,
  comment VARCHAR(500) NOT NULL,
  painting_id INTEGER,
  user_id INTEGER
);


CREATE TABLE likes (
  id SERIAL4 PRIMARY KEY,
  painting_id INTEGER,
  user_id INTEGER
);
