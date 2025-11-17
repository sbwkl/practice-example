CREATE TABLE `dynamic_func` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `func_name` varchar(255) NOT NULL,
  `func_key` varchar(255) NOT NULL,
  `func_type` varchar(255) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
);
