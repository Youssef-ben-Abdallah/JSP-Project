CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(100),
    role VARCHAR(20)
);

INSERT INTO users(username,password,role) VALUES ('admin','admin','ADMIN');

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    description TEXT
);

INSERT INTO categories(name,description) VALUES
('Smartphones','Téléphones 5G haut de gamme'),
('Casques Audio','Casques Bluetooth et ANC');

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150),
    description TEXT,
    price DECIMAL(10,2),
    image_url VARCHAR(255),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

INSERT INTO products(name,description,price,image_url,category_id) VALUES
('Galaxy S24','Écran AMOLED, super perf','999.99','assets/img/phone1.jpg',1),
('AirBeat Pro','Casque sans fil ANC','199.99','assets/img/headset1.jpg',2);
