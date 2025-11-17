--liquibase formatted sql

--changeset jules:1.1.8-1
ALTER TABLE `products` ADD COLUMN `description` TEXT;
--rollback ALTER TABLE `products` DROP COLUMN `description`;
