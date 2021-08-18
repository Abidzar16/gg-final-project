CREATE DATABASE IF NOT EXISTS `social_media_test`;

USE social_media_test;

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
`id` int(11) AUTO_INCREMENT NOT NULL,
`name` varchar(255) DEFAULT NULL,
`email` varchar(255) DEFAULT NULL,
`bio` varchar(1000) DEFAULT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;