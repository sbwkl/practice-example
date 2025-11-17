--liquibase formatted sql

--changeset jules:1.2.0-1
INSERT INTO `product_categories` (`category_name`) VALUES ('Electronics'), ('Books'), ('Clothing');
--rollback DELETE FROM `product_categories` WHERE `category_name` IN ('Electronics', 'Books', 'Clothing');
