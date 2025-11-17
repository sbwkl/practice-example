--liquibase formatted sql

--changeset jules:1.1.0-1
CREATE TABLE `app_config` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `config_key` varchar(255) NOT NULL,
  `config_value` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `version` varchar(255)
);
--rollback DROP TABLE `app_config`;
