CREATE TABLE `me_message_entrance` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `entrance_name` varchar(255) NOT NULL,
  `entrance_url` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
