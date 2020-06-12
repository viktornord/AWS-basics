CREATE DATABASE testdb;
\c testdb;
CREATE TYPE user_gender AS ENUM ('male', 'female');
CREATE TABLE users(id serial PRIMARY KEY, username varchar(255) NOT NULL, gender user_gender);
INSERT INTO users(username, gender) VALUES ('Viktor', 'male'), ('Sara', 'female');
SELECT * FROM users;
