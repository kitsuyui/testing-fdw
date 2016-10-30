CREATE DATABASE IF NOT EXISTS fdw_challenge;

USE fdw_challenge;

CREATE TABLE IF NOT EXISTS sample (id int PRIMARY KEY AUTO_INCREMENT, value float NOT NULL);
INSERT INTO sample (value)
VALUES (1.0)
     , (2.0)
     , (3.0)
     , (4.0);
