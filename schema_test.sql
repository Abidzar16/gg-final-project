CREATE DATABASE IF NOT EXISTS `social_media_test`;

USE social_media_test;

DROP TABLE IF EXISTS `comments`;
DROP TABLE IF EXISTS `posts`;
DROP TABLE IF EXISTS `users`;

CREATE TABLE IF NOT EXISTS `users` (
    `id` varchar(11) NOT NULL,
    `name` varchar(255) NOT NULL,
    `email` varchar(255) NOT NULL,
    `bio` varchar(1000) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `posts` (
    `id` varchar(11) NOT NULL,
    `content` varchar(1000) NOT NULL,
    `attachment` varchar(255) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT NOW(),
    `user_id` varchar(11),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `comments` (
    `id` varchar(11) NOT NULL,
    `content` varchar(1000) NOT NULL,
    `created_at` TIMESTAMP DEFAULT NOW(),
    `user_id` varchar(11),
    `post_id` varchar(11),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `users`(`id`),
    FOREIGN KEY (`post_id`) REFERENCES `posts`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;