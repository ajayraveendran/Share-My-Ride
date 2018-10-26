CREATE DATABASE share_my_ride;

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  name VARCHAR(200),
  username VARCHAR(200),
  email VARCHAR(200),
  password_digest VARCHAR(400),
  dob TIMESTAMP,
  suburb VARCHAR(200)
);

CREATE TABLE bikes(
  id SERIAL PRIMARY KEY,
  owner_id INTEGER, 
  make VARCHAR(100),
  model VARCHAR(100),
  lams BIT,
  image_url VARCHAR(400),
  year VARCHAR(4),
  daily_rate NUMERIC(7,2),
  FOREIGN KEY (owner_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE bookings(
  id SERIAL PRIMARY KEY,
  seller_id INTEGER,
  bike_id INTEGER,
  booking_start TIMESTAMP,
  booking_end TIMESTAMP,
  FOREIGN KEY (seller_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (bike_id) REFERENCES bikes (id) ON DELETE CASCADE
);
  -- daily_rate NUMERIC(7,2)
