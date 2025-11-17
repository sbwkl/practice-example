--liquibase formatted sql

--changeset jules:1.1.9-1
CREATE INDEX `idx_orders_user_id` ON `orders` (`user_id`);
--rollback DROP INDEX `idx_orders_user_id`;
