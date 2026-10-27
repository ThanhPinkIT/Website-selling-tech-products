CREATE DATABASE IF NOT EXISTS web_ban_hang
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE web_ban_hang;

-- Drop existing tables to prevent "Table already exists" error
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- =========================================
-- USERS
-- =========================================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('admin','customer') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================================
-- CATEGORIES
-- =========================================

CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- =========================================
-- PRODUCTS
-- =========================================

CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(12,2) NOT NULL,
    quantity INT DEFAULT 0,
    image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (category_id)
        REFERENCES categories(id)
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- =========================================
-- ORDERS
-- =========================================

CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_money DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'COD',
    status ENUM(
        'Pending',
        'Processing',
        'Shipping',
        'Completed',
        'Cancelled'
    ) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- ORDER DETAILS
-- =========================================

CREATE TABLE order_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(12,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES orders(id)
        ON DELETE CASCADE,

    FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- =========================================
-- PRODUCT REVIEWS
-- =========================================

CREATE TABLE IF NOT EXISTS reviews (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating TINYINT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id)
        REFERENCES users(id),

    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id)
        REFERENCES products(id),

    CONSTRAINT chk_reviews_rating
        CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

-- =========================================
-- SAMPLE CATEGORY DATA
-- =========================================

INSERT INTO categories (id, name)
VALUES
(1, 'Laptop'),
(2, 'Điện thoại'),
(3, 'Phụ kiện'),
(4, 'Gaming'),
(5, 'Màn hình'),
(6, 'Máy tính bảng');

-- =========================================
-- ADMIN ACCOUNT
-- Username: admin
-- Password: admin123
-- =========================================

INSERT INTO users
(
username,
password,
fullname,
email,
role
)
VALUES
(
'admin',
'$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
'Administrator',
'admin@gmail.com',
'admin'
);


-- =========================================
-- SAMPLE PRODUCTS 
-- =========================================

INSERT INTO products
(id, category_id, name, description, price, quantity, image)
VALUES
(1, 2, 'iPhone 18 Pro Max',
'Điện thoại Apple iPhone 18 Pro Max',
32990000, 20, 'iphone18promax.jpg'),

(2, 2, 'Samsung Galaxy S25 Ultra',
'Điện thoại Samsung cao cấp',
29990000, 15, 's25ultra.jpg'),

(3, 6, 'iPad Air M3',
'Máy tính bảng Apple iPad Air M3',
16990000, 18, 'ipadairm3.jpg'),

(4, 5, 'LG UltraGear 27 inch',
'Màn hình gaming LG 27 inch',
5990000, 12, 'lgultragear.jpg'),

(5, 1, 'MacBook Air M3',
'Laptop Apple MacBook Air M3',
24990000, 10, 'macbookm3.jpg'),

(6, 1, 'ASUS TUF Gaming F15',
'Laptop gaming ASUS',
18990000, 10, 'asus.jpg'),

(7, 2, 'Xiaomi 14',
'Điện thoại Xiaomi',
14990000, 15, 'xiaomi14.jpg'),

(8, 3, 'Chuột Logitech G304',
'Chuột gaming không dây',
790000, 25, 'g304.jpg'),

(9, 3, 'Apple Watch Series 10',
'Đồng hồ thông minh Apple',
9990000, 15, 'applewatch10.jpg'),

(10, 3, 'AirPods Pro 2',
'Tai nghe không dây Apple',
5990000, 20, 'airpodspro2.jpg'),

(11, 3, 'Bàn phím Logitech G Pro X',
'Bàn phím gaming cơ',
2990000, 12, 'logitechgprox.jpg'),

(12, 5, 'Dell UltraSharp 27 inch',
'Màn hình Dell 27 inch',
7990000, 10, 'dellultrasharp.jpg');

-- =========================================
-- SAMPLE PRODUCT REVIEWS
-- =========================================

INSERT INTO reviews
(user_id, product_id, rating, comment)
VALUES
(1, 1, 5, 'iPhone 18 thiet ke dep, su dung muot'),
(1, 2, 4, 'Samsung chup anh dep, pin tot'),
(1, 3, 5, 'iPad phu hop hoc tap va giai tri'),
(1, 4, 5, 'Man hinh LG hien thi sac net'),
(1, 5, 4, 'MacBook mong nhe, hieu nang tot'),
(1, 6, 5, 'Laptop ASUS choi game muot'),
(1, 7, 4, 'Xiaomi cau hinh tot, gia hop ly'),
(1, 8, 5, 'Chuot Logitech cam thoai mai'),
(1, 9, 5, 'Apple Watch thiet ke dep, nhieu tinh nang'),
(1, 10, 5, 'AirPods am thanh tot, chong on hieu qua'),
(1, 11, 4, 'Ban phim Logitech go em, phan hoi tot'),
(1, 12, 5, 'Man hinh Dell sac net, mau sac dep');

-- =========================================
-- DATABASE VERIFICATION
-- =========================================

SELECT * FROM categories;
SELECT * FROM products;
SELECT * FROM users;
SELECT * FROM reviews;

-- =========================================
-- PRODUCT RATING STATISTICS
-- =========================================

SELECT
    p.id,
    p.name,
    COUNT(r.id) AS total_reviews,
    COALESCE(
        ROUND(AVG(r.rating), 1), 0
    ) AS average_rating
FROM products p
LEFT JOIN reviews r
    ON p.id = r.product_id
GROUP BY p.id, p.name
ORDER BY average_rating DESC;

-- =========================================
-- INVENTORY STATISTICS
-- =========================================

SELECT
    p.id,
    p.name,
    c.name AS category_name,
    p.price,
    p.quantity
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.id
ORDER BY p.quantity ASC;
-- =========================================
-- SALES STATISTICS
-- =========================================

SELECT
    COUNT(*) AS total_orders,
    COALESCE(
        SUM(total_money),
        0
    ) AS total_revenue
FROM orders
WHERE status = 'Completed';
