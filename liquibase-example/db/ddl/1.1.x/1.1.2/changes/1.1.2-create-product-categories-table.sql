--liquibase formatted sql

--changeset jules:1.1.2-1
CREATE TABLE `product_categories` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `category_name` varchar(255) NOT NULL,
  `parent_category_id` INTEGER,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
--rollback DROP TABLE `product_categories`;
