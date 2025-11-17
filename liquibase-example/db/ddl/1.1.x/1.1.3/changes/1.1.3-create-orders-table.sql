--liquibase formatted sql

--changeset jules:1.1.3-1
CREATE TABLE `orders` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` INTEGER NOT NULL,
  `order_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `total_amount` decimal(10, 2) NOT NULL,
  `status` varchar(50) NOT NULL
);
--rollback DROP TABLE `orders`;
