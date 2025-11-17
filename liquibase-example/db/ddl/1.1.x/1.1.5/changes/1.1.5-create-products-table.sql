--liquibase formatted sql

--changeset jules:1.1.5-1
CREATE TABLE `products` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `product_name` varchar(255) NOT NULL,
  `category_id` INTEGER NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `stock_quantity` INTEGER NOT NULL
);
--rollback DROP TABLE `products`;
