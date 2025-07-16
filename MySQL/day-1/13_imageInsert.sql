CREATE DATABASE test;
USE test;

CREATE TABLE image (
  id INT AUTO_INCREMENT PRIMARY KEY,
  file_name VARCHAR(255),
  file_data LONGBLOB
);


SHOW VARIABLES LIKE 'secure_file_priv';
SELECT LENGTH(LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/a.jpg'));


INSERT INTO image (file_name, file_data)
VALUES (
  'a.jpg',
  LOAD_FILE('C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/a.jpg')
);


SELECT id, file_name, LENGTH(file_data) AS size_in_bytes
FROM image;