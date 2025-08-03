CREATE TABLE IF NOT EXISTS `dynamic_menu_configs` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `identifier` varchar(50) NOT NULL,
    `slot_id` varchar(20) NOT NULL,
    `icon` varchar(100) NOT NULL,
    `tooltip` varchar(50) NOT NULL,
    `event_type` enum('client','server','command') NOT NULL,
    `event` varchar(100) NOT NULL,
    `close_menu` tinyint(1) NOT NULL DEFAULT 1,
    `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_user_slot` (`identifier`, `slot_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;