--liquibase formatted sql

--changeset jules:1.1.4-1
CREATE TABLE `order_items` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `order_id` INTEGER NOT NULL,
  `product_id` INTEGER NOT NULL,
  `quantity` INTEGER NOT NULL,
  `unit_price` decimal(10, 2) NOT NULL
);
--rollback DROP TABLE `order_items`;
