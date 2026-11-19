CREATE DATABASE IF NOT EXISTS sales;
USE sales;

CREATE TABLE sales_data (
    product_id INT UNSIGNED NOT NULL,
    customer_id INT UNSIGNED NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT UNSIGNED NOT NULL,
    `timestamp` DATETIME NOT NULL
);
