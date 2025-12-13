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

INSERT INTO users (username, password, role)
VALUES ('admin', 'admin', 'ADMIN');


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
                                               ('Audio','Headphones and speakers'),
                                               ('Wearables','Smart wearable devices'),
                                               ('Smart Home','Connected home solutions'),
                                               ('Laptops','Portable computing devices'),
                                               ('Gaming','Gaming hardware and accessories'),
                                               ('Cameras','Photography and video equipment'),
                                               ('Accessories','Tech accessories'),
                                               ('Networking','Internet and networking devices'),
                                               ('Office Tech','Office productivity technology');


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
-- Smartphones (1)
('Flagship Phones','High-end smartphones',1),
('Mid Range Phones','Balanced performance phones',1),
('Budget Phones','Affordable smartphones',1),
('Gaming Phones','High performance gaming phones',1),
('Foldable Phones','Foldable display phones',1),

-- Audio (2)
('Wireless Headphones','Bluetooth headphones',2),
('Noise Cancelling','ANC headphones',2),
('Speakers','Portable speakers',2),
('Studio Audio','Professional audio gear',2),
('Gaming Headsets','Headsets for gaming',2),

-- Wearables (3)
('Smartwatches','Smart wearable watches',3),
('Fitness Trackers','Health tracking devices',3),
('AR Glasses','Augmented reality wearables',3),
('Kids Wearables','Wearables for kids',3),
('Luxury Wearables','Premium wearables',3),

-- Smart Home (4)
('Smart Lighting','Connected lights',4),
('Smart Security','Home security devices',4),
('Smart Speakers','Voice assistants',4),
('Smart Climate','Thermostats and climate',4),
('Smart Appliances','Connected appliances',4),

-- Laptops (5)
('Ultrabooks','Thin and light laptops',5),
('Gaming Laptops','High performance laptops',5),
('Business Laptops','Professional laptops',5),
('Student Laptops','Affordable laptops',5),
('2-in-1 Laptops','Convertible laptops',5),

-- Gaming (6)
('Consoles','Gaming consoles',6),
('Controllers','Game controllers',6),
('Gaming PCs','Desktop gaming PCs',6),
('VR Gaming','Virtual reality gaming',6),
('Streaming Gear','Streaming accessories',6),

-- Cameras (7)
('Mirrorless Cameras','Compact cameras',7),
('DSLR Cameras','Professional cameras',7),
('Action Cameras','Outdoor cameras',7),
('Camera Lenses','Photography lenses',7),
('Camera Accessories','Camera gear',7),

-- Accessories (8)
('Chargers','Fast chargers',8),
('Cables','USB and HDMI cables',8),
('Power Banks','Portable batteries',8),
('Phone Cases','Protective cases',8),
('Stands & Mounts','Device holders',8),

-- Networking (9)
('Routers','WiFi routers',9),
('Mesh Systems','Whole home WiFi',9),
('Modems','Internet modems',9),
('Network Switches','LAN switches',9),
('Range Extenders','WiFi extenders',9),

-- Office Tech (10)
('Printers','Office printers',10),
('Scanners','Document scanners',10),
('Monitors','Office displays',10),
('Keyboards','Productivity keyboards',10),
('Office Accessories','Office tech gear',10);


/* =========================================================
   PRODUCTS
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
                                                                                            ('Galaxy X Pro','Flagship smartphone',999.99,'img/p1.jpg',1,1),
                                                                                            ('Nova Lite','Affordable smartphone',299.99,'img/p2.jpg',1,3),
                                                                                            ('GameMax Phone','Gaming smartphone',699.99,'img/p3.jpg',1,4),
                                                                                            ('Fold X','Foldable smartphone',1299.99,'img/p4.jpg',1,5),
                                                                                            ('SoundAir ANC','Noise cancelling headset',199.99,'img/p5.jpg',2,7),
                                                                                            ('BassBoost Speaker','Portable speaker',149.99,'img/p6.jpg',2,8),
                                                                                            ('Studio Mic Pro','Professional microphone',249.99,'img/p7.jpg',2,9),
                                                                                            ('Pulse Gaming Headset','Gaming headset',129.99,'img/p8.jpg',2,10),
                                                                                            ('FitWatch 2','Fitness smartwatch',179.99,'img/p9.jpg',3,12),
                                                                                            ('LuxWatch Elite','Luxury smartwatch',499.99,'img/p10.jpg',3,15),

                                                                                            ('Smart Bulb RGB','Color smart bulb',39.99,'img/p11.jpg',4,16),
                                                                                            ('SecureCam Pro','Security camera',129.99,'img/p12.jpg',4,17),
                                                                                            ('Voice Hub','Smart speaker',99.99,'img/p13.jpg',4,18),
                                                                                            ('Smart Thermo','Smart thermostat',199.99,'img/p14.jpg',4,19),
                                                                                            ('UltraBook Air','Lightweight laptop',999.99,'img/p15.jpg',5,21),

                                                                                            ('GameBook X','Gaming laptop',1799.99,'img/p16.jpg',5,22),
                                                                                            ('BizBook Pro','Business laptop',1199.99,'img/p17.jpg',5,23),
                                                                                            ('FlexBook','2-in-1 laptop',899.99,'img/p18.jpg',5,25),
                                                                                            ('NextGen Console','Gaming console',499.99,'img/p19.jpg',6,26),
                                                                                            ('VR Vision','VR headset',399.99,'img/p20.jpg',6,29),

                                                                                            ('StreamCam','Streaming camera',149.99,'img/p21.jpg',6,30),
                                                                                            ('MirrorShot M5','Mirrorless camera',899.99,'img/p22.jpg',7,31),
                                                                                            ('ActionGo','Action camera',299.99,'img/p23.jpg',7,33),
                                                                                            ('ZoomLens 50mm','Camera lens',499.99,'img/p24.jpg',7,34),
                                                                                            ('Camera Tripod','Camera accessory',79.99,'img/p25.jpg',7,35),

                                                                                            ('Fast Charger 65W','USB-C charger',39.99,'img/p26.jpg',8,36),
                                                                                            ('PowerMax Bank','Power bank',59.99,'img/p27.jpg',8,38),
                                                                                            ('Protect Case','Phone case',29.99,'img/p28.jpg',8,39),
                                                                                            ('Desk Stand','Device stand',49.99,'img/p29.jpg',8,40),
                                                                                            ('WiFi Router AX','High speed router',199.99,'img/p30.jpg',9,41),

                                                                                            ('Mesh WiFi Set','Mesh system',299.99,'img/p31.jpg',9,42),
                                                                                            ('Range Extender','WiFi extender',89.99,'img/p32.jpg',9,45),
                                                                                            ('Office Printer','Laser printer',249.99,'img/p33.jpg',10,46),
                                                                                            ('4K Monitor','Office monitor',399.99,'img/p34.jpg',10,48),
                                                                                             ('Mechanical Keyboard','Office keyboard',129.99,'img/p35.jpg',10,49);


/* =========================================================
   ORDERS
   ========================================================= */
CREATE TABLE orders (
                        id INT PRIMARY KEY AUTO_INCREMENT,
                        user_id INT NOT NULL,
                        total_amount DECIMAL(10,2) NOT NULL,
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        CONSTRAINT fk_order_user FOREIGN KEY (user_id)
                            REFERENCES users(id)
                            ON DELETE CASCADE
);

CREATE TABLE order_items (
                             id INT PRIMARY KEY AUTO_INCREMENT,
                             order_id INT NOT NULL,
                             product_id INT NOT NULL,
                             quantity INT NOT NULL,
                             unit_price DECIMAL(10,2) NOT NULL,
                             CONSTRAINT fk_order_item_order FOREIGN KEY (order_id)
                                 REFERENCES orders(id)
                                 ON DELETE CASCADE,
                             CONSTRAINT fk_order_item_product FOREIGN KEY (product_id)
                                 REFERENCES products(id)
                                 ON DELETE CASCADE
);


/* =========================================================
   PROMOTIONS
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

INSERT INTO promotions (title, description, discount_type, discount_value, start_time, end_time, category_id, subcategory_id) VALUES
                                                                                                     ('Spring Launch','Seasonal launch discount','PERCENTAGE',20,
                                                                                                      NOW() - INTERVAL 1 DAY, NOW() + INTERVAL 7 DAY, NULL, NULL),
                                                                                                     ('Tech Week','Flat discount on accessories','FIXED_AMOUNT',25,
                                                                                                      NOW() - INTERVAL 2 DAY, NOW() + INTERVAL 3 DAY, 1, 2);
