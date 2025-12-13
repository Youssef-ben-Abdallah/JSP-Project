/* =========================================================
   DATABASE RESET
   ========================================================= */
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
USE ecommerce_db;

/* =========================================================
   USERS
   ========================================================= */
CREATE TABLE users (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       username VARCHAR(50) UNIQUE NOT NULL,
                       password VARCHAR(100) NOT NULL,
                       role VARCHAR(20) NOT NULL
);

INSERT INTO users (username, password, role) VALUES
                                                 ('admin', 'admin', 'ADMIN'),
                                                 ('john', '1234', 'USER'),
                                                 ('sarah', '1234', 'USER'),
                                                 ('alex', '1234', 'USER');

/* =========================================================
   CATEGORIES
   ========================================================= */
CREATE TABLE categories (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            name VARCHAR(100) NOT NULL,
                            description TEXT
);

INSERT INTO categories (name, description) VALUES
                                               ('Smartphones','Latest mobile technology'),
                                               ('Accessories','Tech accessories');

/* =========================================================
   SUBCATEGORIES
   ========================================================= */
CREATE TABLE subcategories (
                               id INT PRIMARY KEY AUTO_INCREMENT,
                               name VARCHAR(120) NOT NULL,
                               description TEXT,
                               category_id INT NOT NULL,
                               CONSTRAINT fk_sub_category
                                   FOREIGN KEY (category_id)
                                       REFERENCES categories(id)
                                       ON DELETE CASCADE
);

INSERT INTO subcategories (name, description, category_id) VALUES
                                                               ('Flagship Phones','High-end smartphones',1),
                                                               ('Budget Phones','Affordable smartphones',1),
                                                               ('Chargers','Fast chargers',2);

/* =========================================================
   PRODUCTS (10)
   ========================================================= */
CREATE TABLE products (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          name VARCHAR(150) NOT NULL,
                          description TEXT,
                          price DECIMAL(10,2) NOT NULL,
                          image_url VARCHAR(255),
                          category_id INT NOT NULL,
                          subcategory_id INT,
                          CONSTRAINT fk_product_category
                              FOREIGN KEY (category_id)
                                  REFERENCES categories(id),
                          CONSTRAINT fk_product_subcategory
                              FOREIGN KEY (subcategory_id)
                                  REFERENCES subcategories(id)
                                  ON DELETE SET NULL
);

INSERT INTO products (name, description, price, image_url, category_id, subcategory_id) VALUES
                                                                                            ('Galaxy Ultra X','Flagship smartphone',1099.99,'img/p1.jpg',1,1),
                                                                                            ('iPhone Z Pro','High-end smartphone',1199.99,'img/p2.jpg',1,1),
                                                                                            ('Pixel Max','Android flagship phone',999.99,'img/p3.jpg',1,1),

                                                                                            ('Nova Lite','Budget smartphone',299.99,'img/p4.jpg',1,2),
                                                                                            ('Redmi Go','Affordable phone',199.99,'img/p5.jpg',1,2),

                                                                                            ('Fast Charger 65W','USB-C fast charger',39.99,'img/p6.jpg',2,3),
                                                                                            ('Wireless Charger','Wireless charging pad',49.99,'img/p7.jpg',2,3),
                                                                                            ('Car Charger','Dual USB car charger',24.99,'img/p8.jpg',2,3),
                                                                                            ('Power Adapter','High power charger',59.99,'img/p9.jpg',2,3),
                                                                                            ('Travel Charger','Universal charger',34.99,'img/p10.jpg',2,3);

/* =========================================================
   ORDERS
   ========================================================= */
CREATE TABLE orders (
                        id INT PRIMARY KEY AUTO_INCREMENT,
                        user_id INT NOT NULL,
                        total_amount DECIMAL(10,2) NOT NULL,
                        status VARCHAR(50) NOT NULL DEFAULT 'PENDING_CONFIRMATION',
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        CONSTRAINT fk_order_user
                            FOREIGN KEY (user_id)
                                REFERENCES users(id)
                                ON DELETE CASCADE
);

CREATE TABLE order_items (
                             id INT PRIMARY KEY AUTO_INCREMENT,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             quantity INT NOT NULL,
                             unit_price DECIMAL(10,2) NOT NULL,
                             CONSTRAINT fk_order_item_order
                                 FOREIGN KEY (order_id)
                                     REFERENCES orders(id)
                                     ON DELETE CASCADE,
                             CONSTRAINT fk_order_item_product
                                 FOREIGN KEY (product_id)
                                     REFERENCES products(id)
                                     ON DELETE CASCADE
);

/* =========================================================
   PROMOTIONS (NO NULL CATEGORY / SUBCATEGORY)
   ========================================================= */
CREATE TABLE promotions (
                            id INT PRIMARY KEY AUTO_INCREMENT,
                            title VARCHAR(150) NOT NULL,
                            description TEXT,
                            discount_type VARCHAR(20) NOT NULL,
                            discount_value DECIMAL(10,2) NOT NULL,
                            start_time DATETIME NOT NULL,
                            end_time DATETIME NOT NULL,
                            category_id INT NULL,
                            subcategory_id INT NULL,
                            created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO promotions
(title, description, discount_type, discount_value, start_time, end_time, category_id, subcategory_id)
VALUES
    ('Flagship Sale','Discount on flagship phones','PERCENTAGE',15,
     NOW() - INTERVAL 1 DAY, NOW() + INTERVAL 7 DAY, 1, 1),

    ('Budget Boost','Save on budget phones','FIXED_AMOUNT',30,
     NOW(), NOW() + INTERVAL 5 DAY, 1, 2),

    ('Charger Deals','Discount on chargers','PERCENTAGE',20,
     NOW(), NOW() + INTERVAL 6 DAY, 2, 3);
