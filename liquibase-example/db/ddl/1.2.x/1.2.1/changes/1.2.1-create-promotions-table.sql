--liquibase formatted sql

--changeset jules:1.2.1-2
CREATE TABLE `promotions` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `promotion_name` varchar(255) NOT NULL,
  `discount_percentage` decimal(5, 2) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL
);
--rollback DROP TABLE `promotions`;
