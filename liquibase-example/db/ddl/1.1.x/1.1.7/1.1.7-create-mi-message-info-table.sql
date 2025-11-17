CREATE TABLE `mi_message_info` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `message_id` varchar(255) NOT NULL,
  `message_content` TEXT,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
