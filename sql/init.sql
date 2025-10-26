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
('Casques Audio','Casques Bluetooth et ANC'),
('Accessoires Connectés','Gadgets pour améliorer vos expériences numériques');

CREATE TABLE subcategories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(120),
    description TEXT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

INSERT INTO subcategories(name,description,category_id) VALUES
('Flagship Series','Dernières innovations mobiles',1),
('Photo & Créateurs','Pour les créateurs de contenu',1),
('Casques Premium','Immersion et ANC haut de gamme',2),
('Basses & Sport','Pensés pour le mouvement',2),
('Maison Connectée','Éclairage, audio multiroom',3),
('Mobilité','Accessoires pour voyageurs',3);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150),
    description TEXT,
    price DECIMAL(10,2),
    image_url VARCHAR(255),
    category_id INT,
    subcategory_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE SET NULL
);

INSERT INTO products(name,description,price,image_url,category_id,subcategory_id) VALUES
('Galaxy S24','Écran AMOLED, super perf','999.99','assets/img/phone1.jpg',1,1),
('AirBeat Pro','Casque sans fil ANC','199.99','assets/img/headset1.jpg',2,3),
('Pixel Lens Kit','Objectif mobile grand angle','149.00','assets/img/lens.jpg',1,2),
('Aurora Smart Lamp','Lampe connectée multizone','89.00','assets/img/lamp.jpg',3,5);

CREATE TABLE promotions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    discount_type VARCHAR(20) NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL DEFAULT 0,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO promotions(title, description, discount_type, discount_value, start_time, end_time) VALUES
('Lancement Printemps', 'Réduction spéciale sur la collection printemps immersive.', 'PERCENTAGE', 20,
 NOW() - INTERVAL 1 DAY, NOW() + INTERVAL 5 DAY),
('Offre Fidélité', 'Remise immédiate sur les accessoires premium.', 'FIXED_AMOUNT', 30,
 NOW() - INTERVAL 2 HOUR, NOW() + INTERVAL 2 DAY);
