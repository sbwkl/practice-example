--liquibase formatted sql

--changeset jules:1.2.1-1
CREATE TABLE `reviews` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `product_id` INTEGER NOT NULL,
  `user_id` INTEGER NOT NULL,
  `rating` INTEGER NOT NULL,
  `comment` TEXT,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
--rollback DROP TABLE `reviews`;
