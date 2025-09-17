CREATE TABLE  IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `creator_hash` varchar(100) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  `tid` varchar(255) DEFAULT NULL,
  `pw` varchar(255) NOT NULL,
  `super` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_unique` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

CREATE TABLE  IF NOT EXISTS `acls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `topic` varchar(255) NOT NULL,
  `rw` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_topic_unique` (`topic`,`username`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;