--liquibase formatted sql

--changeset jules:1.1.1-1
CREATE TABLE `user_sessions` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `user_id` INTEGER NOT NULL,
  `session_token` varchar(255) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
--rollback DROP TABLE `user_sessions`;
