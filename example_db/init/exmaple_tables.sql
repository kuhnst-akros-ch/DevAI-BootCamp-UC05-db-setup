-- Drop tables if they exist
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS product_categories;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS shipping_addresses;

-- Create Customers table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Create Categories table
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    parent_category_id INTEGER REFERENCES categories(category_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Product Categories junction table
CREATE TABLE product_categories (
    product_id INTEGER REFERENCES products(product_id),
    category_id INTEGER REFERENCES categories(category_id),
    PRIMARY KEY (product_id, category_id)
);

-- Create Shipping Addresses table
CREATE TABLE shipping_addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    street_address VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL DEFAULT 'United States',
    is_default BOOLEAN DEFAULT false
);

-- Create Orders table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    shipping_address_id INTEGER REFERENCES shipping_addresses(address_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
    total_amount DECIMAL(10,2) NOT NULL,
    shipping_fee DECIMAL(10,2) DEFAULT 0.00,
    tracking_number VARCHAR(50)
);

-- Create Order Items table
CREATE TABLE order_items (
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id)
);

-- Insert sample data into Customers
INSERT INTO customers (first_name, last_name, email, phone, last_login) VALUES
('John', 'Doe', 'john.doe@email.com', '555-0100', CURRENT_TIMESTAMP - INTERVAL '2 days'),
('Jane', 'Smith', 'jane.smith@email.com', '555-0101', CURRENT_TIMESTAMP - INTERVAL '1 day'),
('Robert', 'Johnson', 'robert.j@email.com', '555-0102', CURRENT_TIMESTAMP - INTERVAL '5 hours'),
('Maria', 'Garcia', 'maria.g@email.com', '555-0103', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
('David', 'Brown', 'david.b@email.com', '555-0104', CURRENT_TIMESTAMP - INTERVAL '30 minutes');

-- Insert sample data into Categories
INSERT INTO categories (name, description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Apparel and fashion items'),
('Books', 'Physical and digital books'),
('Home & Garden', 'Home improvement and garden supplies'),
('Sports & Outdoors', 'Sports equipment and outdoor gear');

-- Insert sample data into Products
INSERT INTO products (name, description, price, sku, stock_quantity) VALUES
('Smartphone Pro Max', '6.7-inch display, 256GB storage', 999.99, 'PHONE-001', 50),
('Laptop Ultra', '15-inch laptop with 16GB RAM', 1299.99, 'LAPTOP-001', 30),
('Cotton T-Shirt', 'Classic fit cotton t-shirt', 19.99, 'SHIRT-001', 200),
('Running Shoes', 'Lightweight running shoes', 89.99, 'SHOES-001', 100),
('Smart Watch', 'Fitness tracking smart watch', 199.99, 'WATCH-001', 75),
('Wireless Earbuds', 'Noise-cancelling earbuds', 149.99, 'AUDIO-001', 150),
('Yoga Mat', 'Non-slip exercise yoga mat', 29.99, 'YOGA-001', 100),
('Coffee Maker', 'Programmable coffee maker', 79.99, 'COFFEE-001', 45),
('Backpack', 'Water-resistant hiking backpack', 49.99, 'BAG-001', 80),
('desk Lamp', 'LED desk lamp with USB port', 39.99, 'LAMP-001', 60);

-- Insert sample data into Product Categories
INSERT INTO product_categories (product_id, category_id) VALUES
(1, 1), -- Smartphone in Electronics
(2, 1), -- Laptop in Electronics
(3, 2), -- T-Shirt in Clothing
(4, 5), -- Running Shoes in Sports
(5, 1), -- Smart Watch in Electronics
(6, 1), -- Earbuds in Electronics
(7, 5), -- Yoga Mat in Sports
(8, 4), -- Coffee Maker in Home & Garden
(9, 5), -- Backpack in Sports
(10, 4); -- Desk Lamp in Home & Garden

-- Insert sample data into Shipping Addresses
INSERT INTO shipping_addresses (customer_id, street_address, city, state, postal_code, country, is_default) VALUES
(1, '123 Main St', 'Austin', 'TX', '78701', 'United States', true),
(2, '456 Oak Ave', 'Portland', 'OR', '97201', 'United States', true),
(3, '789 Pine Rd', 'Seattle', 'WA', '98101', 'United States', true),
(4, '321 Maple Dr', 'Miami', 'FL', '33101', 'United States', true),
(5, '654 Cedar Ln', 'Boston', 'MA', '02101', 'United States', true);

-- Insert sample data into Orders
INSERT INTO orders (customer_id, shipping_address_id, status, total_amount, shipping_fee, tracking_number) VALUES
(1, 1, 'delivered', 1049.98, 10.00, 'TRK123456'),
(2, 2, 'shipped', 229.98, 8.00, 'TRK123457'),
(3, 3, 'processing', 1299.99, 15.00, NULL),
(4, 4, 'pending', 269.98, 12.00, NULL),
(5, 5, 'cancelled', 89.99, 8.00, NULL);

-- Insert sample data into Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 999.99),  -- Smartphone
(1, 6, 1, 49.99),   -- Earbuds
(2, 5, 1, 199.99),  -- Smart Watch
(2, 7, 1, 29.99),   -- Yoga Mat
(3, 2, 1, 1299.99), -- Laptop
(4, 8, 1, 79.99),   -- Coffee Maker
(4, 10, 1, 189.99), -- Desk Lamp
(5, 4, 1, 89.99);   -- Running Shoes

-- Create indexes for better query performance
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
